#!/bin/bash

window=$(wmctrl -l | dmenu -i -l 15 -p "Switch to:" | awk '{print $1}')

[[ -z "$window" ]] && exit 0

win_dec=$(printf "%d" "$window")

wmctrl -i -a "$window"
sleep 0.05
wmctrl -i -a "$window"
