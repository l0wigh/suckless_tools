#!/bin/bash

POW=$(printf "poweroff
reboot" | dmenu -c -l 2 -p "What to do ?") || exit 0

sudo $POW
