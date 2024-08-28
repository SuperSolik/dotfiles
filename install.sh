#!/bin/bash

ln -v -sf $(readlink -f ./nvim/) $HOME/.config/nvim
ln -v -sf $(readlink -f ./wezterm/) $HOME/.config/wezterm
ln -v -sf $(readlink -f ./.ignore) $HOME/.ignore
ln -v -sf $(readlink -f ./.fzf-key-bindings.zsh) $HOME/.fzf-key-bindings.zsh
