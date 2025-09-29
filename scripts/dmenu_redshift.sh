#!/bin/bash

RED=$(printf "on
off" | dmenu -c -l 2 -p "Redshift") || exit 0

if [ $RED = "on" ]; then
	redshift &
elif [ $RED = "off" ]; then
	killall redshift
fi
