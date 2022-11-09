#!/bin/bash
set -ue

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_BASHRC="${DIR}/bashrc.d"
DIR_TMUX="${DIR}/tmux.d"

echo "Installing bash environment from ${DIR}"

# ~/.bashrc
BASHRC=$(cat << EOF
# .bashrc
# =============================================================================
# Bash Settings
# =============================================================================
declare -A bashrc_settings
bashrc_settings['addons']=1
bashrc_settings['aliases']=1
bashrc_settings['bindings']=1
bashrc_settings['colors']=1
bashrc_settings['completions']=1
bashrc_settings['options']=1
bashrc_settings['prompt']=1

# Lib settings
bashrc_settings['lib/archives']=1
bashrc_settings['lib/commons']=1
bashrc_settings['lib/datetime']=1
bashrc_settings['lib/features']=1
bashrc_settings['lib/files']=1
bashrc_settings['lib/find']=1
bashrc_settings['lib/openssl']=1
bashrc_settings['lib/testing']=1
bashrc_settings['lib/fzf']=1
bashrc_settings['lib/gpg-ssh']=0

# Lib devel settings
bashrc_settings['lib/devel/commons']=1
bashrc_settings['lib/devel/git']=0
bashrc_settings['lib/devel/svn']=0
bashrc_settings['lib/devel/watch']=0

source ${DIR_BASHRC}/bashrc
[ -f "./.bashrc2" ] && source "./.bashrc2"
EOF
)

# ~/.tmux.conf
TMUXCONF=$(cat << EOF
# .tmux.conf
source-file ${DIR_TMUX}/tmux.conf
source-file ${DIR_TMUX}/tmuxline.conf
EOF
)


#
# Install for selected users
#
if [ $# -eq 0 ]; then
  USERS=$(id -un)
elif [ "$1" == "--all" ]; then
  if ! [ "$(id -u)" = 0 ]; then
    echo "This script must be run as root"
    exit 1
  fi
  USERS=$(getent passwd | grep /home | cut -d: -f1 | tr '\n' ' ' && id 0 -un)
else
  USERS=${@:1}
fi

echo "Selected users: $USERS"
for USER in $USERS; do
  user_home=$(eval echo "~$USER")
  user_bashrc="${user_home}/.bashrc"
  user_tmuxconf="${user_home}/.tmux.conf"
  user_tpm="${user_home}/.tmux/plugins/tpm"

  echo "$BASHRC" > "$user_bashrc" && chown ${USER} "$user_bashrc" || exit 1
  echo "$TMUXCONF" > "$user_tmuxconf" && chown ${USER} "$user_tmuxconf" || exit 2

  # Install tmux plugin manager
  if [ -d "${user_tpm}" ]; then
    cd "${user_tpm}" || exit 1
    git pull
  else
    mkdir -p "${user_tpm}" && chown ${USER} "${user_home}/.tmux" -R || exit 1
    cd "${user_tpm}" || exit 1
    git clone "https://github.com/tmux-plugins/tpm" "${user_tpm}" || exit 1
  fi

  echo "Installed the bashrc, tmux environment for user '$USER' successfully! Enjoy :-)"
done

exit 0

### EOF ###
