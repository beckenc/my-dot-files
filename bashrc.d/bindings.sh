#!/bin/bash

# +-------------------------------------------------
# | Usefull Bindings
# +-------------------------------------------------

bind "set completion-ignore-case On" # filename matching and completion in a case-insensitive fashion
bind "set bell-style none"           # no bell
bind "set show-all-if-ambiguous On"  # show list automatically, without double tab

# map "ctl" to move forward and back in words
#  gnome / others (escape + arrow key)
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
#  konsole / xterm / rxvt (escape + arrow key)
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'
#  gnome / konsole / others (control + arrow key)
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

# map "page up" and "page down" to search history based on current cmdline
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

