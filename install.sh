#!/bin/bash
set -ue

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo 'Installing bash environment from '$DIR

BASHRC=$(cat << EOF
# .bashrc
source ${DIR}/bashrc.d/bashrc
[ -f "${DIR}"/my_bashrc.sh ] && source "${DIR}"/my_bashrc.sh
EOF
)



if [ $# -eq 0 ]; then
  USERS=$(users)
elif [ $1 == "--all" ]; then
  USERS=$(getent passwd | grep /home | cut -d: -f1 | tr '\n' ' ')
else
  USERS=${@:1}
fi

echo "Selected users: $USERS"
for USER in $USERS; do
  user_home=$(eval echo "~$USER")
  user_bashrc="${user_home}/.bashrc"

  echo "$BASHRC" > "$user_bashrc" && chown ${USER}.${USER} "$user_bashrc" || exit 1
  echo "Installed the bashrc environment for user '$USER' successfully! Enjoy :-)"
done

exit 0

### EOF ###
