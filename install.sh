#!/bin/bash
set -ue

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo 'Installing bash environment from '$DIR

# ~/.bashrc
BASHRC=$(cat << EOF
# .bashrc
source ${DIR}/bashrc.d/bashrc
[ -f "${DIR}"/my_bashrc.sh ] && source "${DIR}"/my_bashrc.sh
EOF
)

# ~/.tmux.conf
TMUXCONF=$(cat << EOF
# .tmux.conf
source-file ${DIR}/tmux.d/tmux.conf
source-file ${DIR}/tmux.d/tmuxline.conf
EOF
)


if [ $# -eq 0 ]; then
  USERS=$(id -un)
elif [ $1 == "--all" ]; then
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

  echo "$BASHRC" > "$user_bashrc" && chown ${USER}.${USER} "$user_bashrc" || exit 1
  echo "$TMUXCONF" > "$user_tmuxconf" && chown ${USER}.${USER} "$user_bashrc" || exit 2
  echo "Installed the bashrc, tmux environment for user '$USER' successfully! Enjoy :-)"
done

exit 0

### EOF ###
