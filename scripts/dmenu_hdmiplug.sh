#!/bin/bash

OPT=$(printf "plugged
unplugged" | dmenu -c -l 3 -p "HDMI-A-0: ") || exit 0

if [ $OPT = "plugged" ]; then
	killall polybar
	xrandr --output HDMI-A-0 --auto --above eDP
	~/.fehbg
	sleep 3
	~/tools/suckless_tools/scripts/multi_polybar.sh
	notify-send -u low "Activate HDMI-A-0"
elif [ $OPT = "unplugged" ]; then
	killall polybar
	xrandr --output HDMI-A-0 --off
	~/.fehbg
	sleep 3
	~/tools/suckless_tools/scripts/multi_polybar.sh
	notify-send -u low "Deactivate HDMI-A-0"
fi

