#!/bin/bash

CURR_DATE=$(date '+%Y-%m-%d-%H:%M:%S')
scrot -s -f -F /tmp/$CURR_DATE.png

if [[ "$1" == "tmp" ]]
then
	xclip -sel clip -t image/png -i "/tmp/$CURR_DATE.png"
else
	VALUE="$(echo "" | dmenu -b -i -p "Name: " <&-)" || exit 0
	mv /tmp/$CURR_DATE.png /home/thomas/screenshots/$VALUE.png
fi
