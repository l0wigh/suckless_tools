#!/bin/bash

cp ~/.Xresources /tmp/Xresources_switcher
COUNT=4

SELECTED=$(printf "gruvbox
iceberg
sakura
sakura-light
rosepine
oxocarbon
catppuccin
vscode
cole
cursor
tokyonight-storm
edge-light
solarized-light
solarized-dark
melange-light" | dmenu -c -l $COUNT -p "Theme: ") || exit 0

$HOME/tools/suckless_tools/scripts/themes/$SELECTED.sh

# cp ~/.config/polybar/$SELECTED.ini ~/.config/polybar/theme.ini

# Reload dunst (NEEDS a fix)
~/tools/suckless_tools/scripts/dunst_xrdb.sh

# Reload St and nvim
pidof nvim | xargs kill -s USR1
pidof hx | xargs kill -s USR1
pidof tabbed | xargs kill -s USR1
sleep 0.1
pidof st | xargs kill -s USR1
$HOME/tools/suckless_tools/scripts/multi_polybar.sh

notify-send -u low "Theme loaded"
