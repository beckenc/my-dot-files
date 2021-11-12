# skip at this point if there is no GPG keyring installed for the current user
declare HOMEDIR=$HOME/.gnupg
declare GPG_CONF="$HOMEDIR"/gpg.conf
declare GPGAGENT_CONF="$HOMEDIR"/gpg-agent.conf

if ! [[ -f "$GPGAGENT_CONF" ]]; then
  mkdir -p "$HOMEDIR"
  echo "use-agent" >> "$GPG_CONF"
  echo "pinentry-program /usr/bin/pinentry" >> "$GPGAGENT_CONF"
  echo "no-grab" >> "$GPGAGENT_CONF"
  echo "default-cache-ttl 1800" >> "$GPGAGENT_CONF"
  echo "enable-ssh-support"  >> "$GPGAGENT_CONF"
fi

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  # NOTE: If GNOME Keyring is installed, it is necessary to deactivate its ssh component.
  # Otherwise, it will overwrite SSH_AUTH_SOCK
  # https://wiki.archlinux.org/title/GNOME/Keyring#Disable_keyring_daemon_components
  export SSH_AUTH_SOCK="$(gpgconf --homedir="$HOMEDIR" --list-dirs agent-ssh-socket)"
fi

export GPG_TTY=$(tty)
if [[ -n "$SSH_CONNECTION" ]] ;then
  export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# The agent is automatically started on demand by gpg, gpgsm, gpgconf, or gpg-connect-agent. Thus there is no reason
# to start it manually. Since I want to use the included SSH Agent I may start the agent at login.
gpg-connect-agent --homedir="$HOMEDIR" updatestartuptty /bye >/dev/null

unset GPG_CONF
unset GPGAGENT_CONF
unset HOMEDIR

#EOF
