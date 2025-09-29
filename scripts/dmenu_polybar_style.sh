#!/bin/bash

OPT=$(printf "simple
squared
rounded" | dmenu -c -l 3 -p "Polybar Style: ") || exit 0

CURR=$(cat ~/.config/polybar/config.ini | grep current | cut -d '=' -f 2 | awk '{$1=$1};1')

sed -i "s/$CURR/$OPT/g" ~/.config/polybar/config.ini
~/tools/suckless_tools/scripts/multi_polybar.sh
