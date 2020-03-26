#!/bin/bash

# setup screen for ssh sessions
if [ "$TERM" != 'screen' ] && [ "$SSH_CONNECTION" != "" ]; then
  if [[ -x /usr/bin/screen ]]; then
    /usr/bin/screen -S sshscreen -d -R -c ${BASHRC_CONFIG}/screenrc
  else
    echo "Failed to setup screen. Package not found!"
  fi
fi

