#!/bin/bash
set -ue

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo 'Installing bash environment from '$DIR

# ~/.bashrc
BASHRC=$(cat << EOF
# .bashrc
source ${DIR}/bashrc.d/bashrc
[ -f "${DIR}"/my_bashrc.sh ] && source "${DIR}"/my_bashrc.sh
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
bashrc_settings['lib/gpg-ssh']=1

# Lib devel settings
bashrc_settings['lib/devel/commons']=1
bashrc_settings['lib/devel/git']=0
bashrc_settings['lib/devel/svn']=0
bashrc_settings['lib/devel/watch']=0

if [ "\${bashrc_settings['colors']}" -eq 1 ]; then
  # some of the scripts have a ugly dependency to colors.sh
  # so we need to source that first
  source "\${BASHRC_CONFIG}/colors.sh"
fi
for FILE in "\${!bashrc_settings[@]}"
do
    # echo "source \$FILE"
    if [ "\${bashrc_settings[\$FILE]}" -eq 1 ]; then
        # echo "source \${BASHRC_CONFIG}/\${FILE}.sh"
        source "\${BASHRC_CONFIG}/\${FILE}.sh"
    fi
done
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
