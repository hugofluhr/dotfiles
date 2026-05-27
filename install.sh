#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MINIMAL=false

for arg in "$@"; do
  [[ "$arg" == "--minimal" ]] && MINIMAL=true
done

# --- zsh (Linux only) ---
if ! command -v zsh &>/dev/null; then
  echo "Installing zsh..."
  sudo apt-get install -y zsh
fi

# --- oh-my-zsh (always) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- zsh-autosuggestions (always) ---
ZSH_AUTOSUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGEST_DIR" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGEST_DIR"
fi

# --- zsh-syntax-highlighting (always) ---
ZSH_HIGHLIGHT_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_HIGHLIGHT_DIR" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_HIGHLIGHT_DIR"
fi

# --- zoxide (always) ---
if ! command -v zoxide &>/dev/null; then
  echo "Installing zoxide..."
  if command -v brew &>/dev/null; then
    brew install zoxide
  else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
fi

if [ "$MINIMAL" = false ]; then
  # --- powerlevel10k theme ---
  P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  fi

  # --- git-open plugin ---
  GIT_OPEN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/git-open"
  if [ ! -d "$GIT_OPEN_DIR" ]; then
    echo "Installing git-open plugin..."
    git clone https://github.com/paulirish/git-open.git "$GIT_OPEN_DIR"
  fi
else
  echo "Minimal mode: skipping powerlevel10k and git-open."
  echo "Note: prompt will fall back to oh-my-zsh default theme."
fi

# --- symlinks ---
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

echo "Creating symlinks..."
for file in "${DOTFILES[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES_DIR/$file"

  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "  Backing up existing $file -> ${file}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -s "$source" "$target"
  echo "  $target -> $source"
done

if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

echo "Done. Log out and back in for zsh to take effect."
