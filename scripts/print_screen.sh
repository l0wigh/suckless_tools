#!/bin/bash

CURR_DATE=$(date '+%Y-%m-%d-%H:%M:%S')
scrot -s -f -F /home/thomas/screenshots/$CURR_DATE.png

VALUE="$(echo "" | dmenu -b -i -p "Name: " <&-)" || exit 0
mv /home/thomas/screenshots/$CURR_DATE.png /home/thomas/screenshots/$VALUE.png
