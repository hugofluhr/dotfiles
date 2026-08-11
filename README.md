# dotfiles

Personal dotfiles for macOS, with portable support for Linux VMs.

## What's included

| File | Purpose |
|---|---|
| `.zshrc` | Zsh config: oh-my-zsh, plugins, conda init |
| `.zshrc.cluster` | Minimal Zsh config for cluster nodes (no oh-my-zsh/p10k) |
| `.zsh/aliases.zsh` | Shell aliases (sourced by `.zshrc`) |
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
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** — inline history suggestions as you type
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** — fish-like command highlighting
- **[fzf](https://github.com/junegunn/fzf)** — fuzzy finder; required by fzf-tab
- **[fzf-tab](https://github.com/Aloxaf/fzf-tab)** — replace zsh's default completion with fzf
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — smarter `cd`; use `z <dir>` to jump based on frecency
- **[git-open](https://github.com/paulirish/git-open)** — open the current repo in the browser

### Tmux

Configured for true color (`RGB`) and extended key support. Works correctly inside modern terminals (iTerm2, Ghostty, WezTerm).

### Ghostty over SSH

Ghostty sets `TERM=xterm-ghostty`. Remote hosts (clusters, VMs) usually don't have that terminfo entry installed, which causes garbled colors, broken arrow/backspace keys, and general weirdness in `vim`/`less`/`htop`/etc. over SSH.

Fix it per host with the `ghostty-install-terminfo` function (defined in `.zsh/aliases.zsh`):

```sh
ghostty-install-terminfo <host>
```

This compiles Ghostty's terminfo entry into `~/.terminfo` on the remote — a per-user operation, no sudo required. On clusters with NFS-shared home directories (e.g. UZH sciencecluster), installing it once from the login node makes it available on compute nodes too.

## Install

Clone the repo and run the install script:

```sh
git clone https://github.com/hugofluhr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This will:
1. Install oh-my-zsh (if not already present)
2. Clone zsh-autosuggestions, zsh-syntax-highlighting, Powerlevel10k, and git-open into oh-my-zsh custom directories
3. Install zoxide (via Homebrew on macOS, curl installer on Linux)
4. Symlink all dotfiles into `~/` (existing files are backed up with a `.bak` extension)

### Minimal install (for temporary VMs)

```sh
./install.sh --minimal
```

Skips Powerlevel10k and git-open. oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting, and zoxide are still installed. The prompt falls back to the oh-my-zsh default theme. Still requires `sudo` — for the cluster use `--cluster` below.

### Cluster install (UZH sciencecluster)

```sh
./install.sh --cluster
```

Symlinks only — no package installs, no `sudo`, no `chsh`. Use this and **not** `--minimal` on the cluster: `--minimal` is for VMs where you have admin rights, and its `sudo apt-get` / `sudo chsh` steps will fail (and abort the script) without them.

Links `.zshrc.cluster` → `~/.zshrc`, plus `.zsh`, `.gitconfig`, and `.tmux.conf`. `.zshrc.cluster` sources the cluster init scripts (`lmod`, `spack`, `slurm`) and has no dependency on oh-my-zsh, p10k, or fzf.

The login shell is left alone, since `chsh` usually isn't available to unprivileged users on the cluster. Run `exec zsh` after logging in, or add a guarded `exec zsh -l` to your shell profile.

### Uninstall

```sh
~/dotfiles/uninstall.sh
```

Removes all symlinks, restores any `.bak` files, and reverts the default shell to bash.

## Machine-specific secrets

If `~/.secrets/env.sh` exists it will be sourced automatically by `.zshrc`. Use it for tokens, API keys, or any env vars that shouldn't be in the repo:

```sh
export GITHUB_TOKEN=...
export SOME_API_KEY=...
```

This file is never tracked — keep it in `~/.secrets/` on each machine separately.

## Notes

- **Conda paths** in `.zshrc` and `.bash_profile` assume miniforge3 at `$HOME/miniforge3`. On machines without conda, the init block fails silently.
- **Homebrew** setup in `.zprofile` is guarded and skipped on Linux.
- **Powerlevel10k** requires a Nerd Font in your terminal emulator to render correctly. Without it, the prompt still works but shows placeholder characters.
