# bash is only ever the entry point here -- hand off to zsh immediately for
# any interactive session (SSH login shells, VS Code's non-login terminal,
# etc.) and let .zshrc / .zshrc.cluster do the real configuration.
if [ -t 1 ] && [ -z "$ZSH_VERSION" ] && command -v zsh >/dev/null 2>&1; then
    exec zsh -l
fi
