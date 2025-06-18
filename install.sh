#!/bin/bash

# Get the absolute path of the dotfiles directory
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Backup and remove existing config directories if they exist
backup_and_remove() {
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
ln -v -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -v -sf "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
ln -v -sf "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

# Create symlinks for individual files
ln -v -sf "$DOTFILES_DIR/.ignore" "$HOME/.ignore"
ln -v -sf "$DOTFILES_DIR/.fzf-key-bindings.zsh" "$HOME/.fzf-key-bindings.zsh"
