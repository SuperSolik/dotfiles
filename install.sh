#!/bin/bash
set -euo pipefail

# Get the absolute path of the dotfiles directory
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

ZSHRC="$HOME/.zshrc"
BLOCK_START="# >>> dotfiles >>>"
BLOCK_END="# <<< dotfiles <<<"

# Backup and remove existing config directories if they exist. Symlinks that
# already point into the dotfiles repository are left alone, so reruns are safe.
backup_and_remove() {
  if [ -L "$1" ] && [ "$(readlink "$1")" = "$DOTFILES_DIR/${1##*/}" ]; then
    return
  fi
  if [ -e "$1" ]; then
    echo "Backing up $1 to ${1}.backup"
    mv "$1" "${1}.backup"
  fi
}

# Backup existing config directories
backup_and_remove "$HOME/.config/nvim"
backup_and_remove "$HOME/.config/wezterm"
backup_and_remove "$HOME/.config/ghostty"

# Ensure .config directory exists
mkdir -p "$HOME/.config"

# Create symlinks for directories (without trailing slashes)
ln -v -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -v -sfn "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
ln -v -sfn "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

# Create symlinks for individual files
ln -v -sfn "$DOTFILES_DIR/.ignore" "$HOME/.ignore"

# Install pure prompt at the latest release, or update an existing checkout.
PURE_DIR="$HOME/.zsh/pure"
PURE_REPO="https://github.com/sindresorhus/pure.git"
PURE_TAG=$(git ls-remote --tags --refs --sort=-v:refname "$PURE_REPO" | awk -F/ 'NR == 1 { print $NF }')

if [ -z "$PURE_TAG" ]; then
  echo "Could not determine the latest pure release" >&2
  exit 1
fi

if [ ! -d "$PURE_DIR" ]; then
  echo "Installing pure $PURE_TAG to $PURE_DIR"
  mkdir -p "$HOME/.zsh"
  git clone --branch "$PURE_TAG" --depth 1 "$PURE_REPO" "$PURE_DIR"
elif [ -d "$PURE_DIR/.git" ]; then
  echo "Updating pure to $PURE_TAG in $PURE_DIR"
  git -C "$PURE_DIR" fetch --tags --force origin
  git -C "$PURE_DIR" checkout --force --detach "$PURE_TAG"
else
  echo "Warning: $PURE_DIR exists but is not a git checkout; leaving it unchanged" >&2
fi

# Remove the old standalone fzf key-bindings file. Only remove it when it is a
# symlink, so a real user file is never deleted.
if [ -L "$HOME/.fzf-key-bindings.zsh" ]; then
  rm -v "$HOME/.fzf-key-bindings.zsh"
fi

# Update ~/.zshrc:
#   1. Drop the previous managed block, if any.
#   2. Drop legacy lines that the managed block now owns.
#   3. Append the fresh managed block.
touch "$ZSHRC"

# Preserve the original zshrc on the first install only.
if ! grep -qF "$BLOCK_START" "$ZSHRC"; then
  echo "Backing up $ZSHRC to ${ZSHRC}.backup"
  cp "$ZSHRC" "${ZSHRC}.backup"
fi

tmp_zshrc=$(mktemp)

awk -v start="$BLOCK_START" -v end="$BLOCK_END" '
  $0 == start { in_block = 1; next }
  $0 == end { in_block = 0; next }
  in_block { next }

  # Old standalone fzf key bindings
  /^[[:space:]]*source[[:space:]].*\.fzf-key-bindings\.zsh/ { next }

  # oh-my-zsh bootstrap (owned by the managed block)
  /^[[:space:]]*(export[[:space:]]+)?ZSH=/ { next }
  /^[[:space:]]*(export[[:space:]]+)?ZSH_THEME=/ { next }
  /^[[:space:]]*zstyle[[:space:]]+.:omz:update./ { next }
  /^[[:space:]]*plugins=\(/ { next }
  /^[[:space:]]*source[[:space:]].*oh-my-zsh\.sh/ { next }

  # pure prompt (owned by the managed block)
  /^[[:space:]]*fpath\+=\(.*\.zsh\/pure/ { next }
  /^[[:space:]]*autoload[[:space:]]+-U[[:space:]]+promptinit/ { next }
  /^[[:space:]]*prompt[[:space:]]+pure/ { next }

  # Core environment and aliases (owned by the managed block)
  /^[[:space:]]*export[[:space:]]+EDITOR=/ { next }
  /^[[:space:]]*export[[:space:]]+GOPATH=/ { next }
  /^[[:space:]]*export[[:space:]]+PATH="\$PATH:\$GOPATH\/bin"/ { next }
  /^[[:space:]]*alias[[:space:]]+(ls|vim|activate|c)=/ { next }

  # Homebrew/fzf environment (owned by the managed block)
  /^[[:space:]]*export[[:space:]]+HOMEBREW_NO_AUTO_UPDATE=/ { next }
  /^[[:space:]]*export[[:space:]]+(FZF_DEFAULT_COMMAND|FZF_CTRL_T_COMMAND|FZF_ALT_C_COMMAND)=/ { next }

  { print }
' "$ZSHRC" > "$tmp_zshrc"
mv "$tmp_zshrc" "$ZSHRC"

cat >> "$ZSHRC" <<'EOF'
# >>> dotfiles >>>
# Managed by ~/Code/dotfiles/install.sh. Changes inside this block are overwritten.

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled
plugins=(git pdm fzf ssh-agent)
source "$ZSH/oh-my-zsh.sh"

# Core environment
export EDITOR="nvim"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Aliases
alias ls="ls -GFh"
alias vim=nvim
alias activate="source .venv/bin/activate"
unalias c 2>/dev/null
c() { open "$@" -a "Visual Studio Code" }

# Pure prompt
if [[ -d "$HOME/.zsh/pure" ]]; then
  fpath+=("$HOME/.zsh/pure")
  autoload -U promptinit; promptinit
  prompt pure
fi

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# fzf
# Default fzf command (used by plain `fzf`)
export FZF_DEFAULT_COMMAND='fd . $HOME -t d -H --exclude ".git"'
# Ctrl+T: files and directories from the current directory
export FZF_CTRL_T_COMMAND='fd --hidden --exclude .git --type f --type d'
# Ctrl+F (fzf's cd widget): directories under $HOME
export FZF_ALT_C_COMMAND='fd --hidden --exclude .git --type d . "$HOME"'

# Match the previous full-height, bottom-up UI (fzf now defaults to 40% and --reverse).
export FZF_CTRL_T_OPTS='--height=100% --layout=default'
export FZF_ALT_C_OPTS='--height=100% --layout=default'
export FZF_CTRL_R_OPTS='--layout=default'

# fzf binds its cd widget to Alt+C by default; use Ctrl+F instead.
bindkey -M emacs '^F' fzf-cd-widget
bindkey -M vicmd '^F' fzf-cd-widget
bindkey -M viins '^F' fzf-cd-widget
# <<< dotfiles <<<
EOF

echo "Updated $ZSHRC"
