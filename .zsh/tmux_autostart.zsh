# Drop straight into a persistent tmux session on interactive SSH logins.
#
# Opt in per machine by creating the marker file:
#
#     touch ~/.tmux_autostart
#
# so shared/login nodes are unaffected until you actually ask for this.
# Override the session name with $TMUX_SESSION -- tmux-proj sets this per
# project so the remote session lines up 1:1 with the local one -- otherwise
# falls back to "main". Skip it for one connection with
# `NO_TMUX_AUTOSTART=1 ssh <host>`.
#
# Every guard below exists to keep this from hijacking a shell that isn't a
# human at an interactive terminal. In practice this mostly doesn't matter:
# non-interactive ssh calls (`ssh host cmd`, scp, rsync, and Claude Code's
# own command-and-exit ssh calls) never source .zshrc at all -- only
# .zshenv -- so they never reach this file in the first place. The checks
# here are the second layer, for anything that does get this far.

[[ -f "$HOME/.tmux_autostart" ]] || return 0
[[ -z "$NO_TMUX_AUTOSTART" ]]    || return 0
[[ -n "$SSH_CONNECTION" ]]       || return 0   # only for actual ssh logins
[[ -z "$TMUX" ]]                 || return 0   # already inside tmux
[[ -o interactive ]]             || return 0
[[ -t 0 && -t 1 ]]               || return 0   # real terminal only
[[ "$TERM" != dumb && "$TERM" != linux ]] || return 0
[[ -z "$VSCODE_INJECTION" && "$TERM_PROGRAM" != vscode ]] || return 0
command -v tmux >/dev/null       || return 0

# Deliberately not `exec` -- that would replace this login shell with the
# tmux client, so detaching (Ctrl-b d) would have nothing to return to and
# would kill the SSH connection along with it. Running it as a plain
# foreground command means detach drops you back into this same shell
# (connection stays open, session keeps running); `exit`/Ctrl-D from there
# closes the connection when you actually mean to.
tmux new-session -A -s "${TMUX_SESSION:-main}"
