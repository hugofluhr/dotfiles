# dotfiles

Personal dotfiles for macOS, with portable support for Linux VMs.

## What's included

| File | Purpose |
|---|---|
| `.zshrc` | Zsh config: oh-my-zsh, plugins, conda init |
| `.zprofile` | Login shell: Homebrew path setup (macOS only, guarded) |
| `.bash_profile` | Bash login shell: conda init |
| `.gitconfig` | Git: user, editor, aliases, LFS |
| `.p10k.zsh` | Powerlevel10k prompt configuration |
| `.tmux.conf` | Tmux: true color, extended keys, passthrough |
| `.condarc` | Conda: channel preferences |
| `.fonts.conf` | Font rendering config |

### Zsh setup

- **[oh-my-zsh](https://ohmyzsh.sh)** — plugin and theme framework
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** — prompt theme (requires a [Nerd Font](https://www.nerdfonts.com))
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** — fish-like command highlighting
- **[git-open](https://github.com/paulirish/git-open)** — open the current repo in the browser

### Tmux

Configured for true color (`RGB`) and extended key support. Works correctly inside modern terminals (iTerm2, Ghostty, WezTerm).

## Install

Clone the repo and run the install script:

```sh
git clone https://github.com/hugofluhr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This will:
1. Install oh-my-zsh (if not already present)
2. Clone zsh-syntax-highlighting, Powerlevel10k, and git-open into oh-my-zsh custom directories
3. Symlink all dotfiles into `~\/` (existing files are backed up with a `.bak` extension)

### Minimal install (for temporary VMs)

```sh
./install.sh --minimal
```

Skips Powerlevel10k and git-open. oh-my-zsh and zsh-syntax-highlighting are still installed. The prompt falls back to the oh-my-zsh default theme.

## Notes

- **Conda paths** in `.zshrc` and `.bash_profile` assume miniforge3 at `$HOME/miniforge3`. On machines without conda, the init block fails silently.
- **Homebrew** setup in `.zprofile` is guarded and skipped on Linux.
- **Powerlevel10k** requires a Nerd Font in your terminal emulator to render correctly. Without it, the prompt still works but shows placeholder characters.
