# Aliases

export GITHUB_USERNAME=hugofluhr

alias tm=tmux-proj

# Install Ghostty's terminfo entry on a remote host (per-user, no sudo needed;
# writes to ~/.terminfo on the remote, which ncurses checks automatically).
# Fixes garbled colors / broken keys when SSHing from Ghostty into hosts that
# don't know about TERM=xterm-ghostty (e.g. clusters, VMs).
ghostty-install-terminfo() {
  if [[ -z "$1" ]]; then
    echo "usage: ghostty-install-terminfo <host>" >&2
    return 1
  fi
  infocmp -x xterm-ghostty | ssh "$1" -- tic -x -
  if ssh "$1" -- infocmp xterm-ghostty >/dev/null 2>&1; then
    echo "OK: xterm-ghostty terminfo installed on $1"
  else
    echo "FAILED: xterm-ghostty terminfo not found on $1 after install" >&2
    return 1
  fi
}
