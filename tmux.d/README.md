# tmux
Using TMUX as Terminal Multiplexer

## Install

Copy tmux.conf into your home directory
```bash
copy tmux.conf ${HOME}/.tmux.conf
```

## Usage

### Create Session

```bash
tmux new-session -s <sessions-name>
```

### Attach Session

```bash
tmux attach-session -t <session-name>
```

### List Sessions

```bash
tmux ls
```

## Tmux Plugin Manager

Installs and loads `tmux` plugins.

### Installed Plugins

    tmux-resurrect: Restore tmux environment after system restart
    tmux-continuum: Continuous saving of tmux environment

## Cheat Sheet

### General

    <C> Ctrl Key
    <M> Alt Key

    Prefix for all commands : <C-a>

    Detach Session          : <Prefix> d

    Reload Configuration    : <Prefix> r

### Windows

    Create Window           : <Prefix> c

    Next Window             : <Prefix> Pageup
    Previous Window         : <Prefix> Pagedown

    Swap Window Next        : <Prefix> <C-n>
    Swap Window Previous    : <Prefix> <C-p>

    Split Window (horzontal): <Prefix> -
    Split Window (vertical) : <Prefix> |

    Rename Window           : <Prefix> ,
    Kill Window             : <Prefix> &

### Panes

    Select Pane Up          : <Prefix> Up
    Select Pane Down        : <Prefix> Down
    Select Pane Left        : <Prefix> Left
    Select Pane Rigth       : <Prefix> Rigth

    Swap Pane Next          : <Prefix> <M-n>
    Swap Pane Previous      : <Prefix> <M-p>
    Swap Panes              : <Prefix> Space

    Resize Pane Up          : <Prefix> <C-Up>
    Resize Pane Down        : <Prefix> <C-Down>
    Resize Pane Left        : <Prefix> <C-Left>
    Resize Pane Right       : <Prefix> <C-Right>

    Zoom Pane               : <Prefix> z

### List Sessions/Windows/Panes

    List Sessions           : <Prefix> s
    List Windows            : <Prefix> w
    List Panes              : <Prefix> q

### Plugin Manager

    Installs new plugins    : <Prefix> I
    Updates plugin(s)       : <Prefix> U
    Uninstall plugins not
    on the plugin list      : <Prefix> <M-u>
    Save session            : <Previx> <C-s>
    Restore session         : <Previx> <C-r>
