#!/bin/bash

OPT=$(printf "next
play/pause
prev" | dmenu -c -l 3 -p "Music Player: ") || exit 0

if [ $OPT = "next" ]; then
	mocp -f
	notify-send -u low "Next Song"
elif [ $OPT = "play/pause" ]; then
	mocp -G
	notify-send -u low "Play/Pause"
elif [ $OPT = "prev" ]; then
	mocp -r
	notify-send -u low "Prev Song"
fi
