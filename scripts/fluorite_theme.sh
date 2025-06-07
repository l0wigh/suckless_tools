#!/bin/bash

cp ~/.Xresources /tmp/Xresources_switcher
COUNT=4

SELECTED=$(printf "gruvbox
iceberg
rosepine
oxocarbon
edge-light
solarized-light
catppuccin" | dmenu -c -l $COUNT -p "Theme: ") || exit 0

$HOME/tools/suckless_tools/scripts/themes/$SELECTED.sh

# Reload dunst
killall dunst && dunst &
notify-send -u low "$SELECTED selected"

# Reload St and nvim
pidof nvim | xargs kill -s USR1
pidof hx | xargs kill -s USR1
pidof st | xargs kill -s USR1

