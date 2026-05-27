#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTFILES=(
  .zsh
  .zshrc
  .zprofile
  .bash_profile
  .gitconfig
  .p10k.zsh
  .tmux.conf
  .condarc
  .fonts.conf
)

echo "Removing symlinks..."
for file in "${DOTFILES[@]}"; do
  target="$HOME/$file"

  if [ -L "$target" ]; then
    rm "$target"
    echo "  Removed $target"

    if [ -e "${target}.bak" ]; then
      mv "${target}.bak" "$target"
      echo "  Restored ${target}.bak -> $target"
    fi
  else
    echo "  Skipping $file (not a symlink)"
  fi
done

if [ "$SHELL" = "$(which zsh)" ]; then
  echo "Reverting default shell to bash..."
  sudo chsh -s "$(which bash)" "$USER"
fi

echo "Done. Log out and back in for shell change to take effect."
