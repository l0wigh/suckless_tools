#!/bin/sh

CUR=$(cat /sys/class/backlight/acpi_video0/brightness)
SCR="amdgpu_bl0"

if [[ "$1" == "up" ]]
then
	echo $(( CUR + 1 )) > /sys/class/backlight/$SCR/brightness
elif [[ "$1" == "down" ]]
then
	echo $(( CUR - 1 )) > /sys/class/backlight/$SCR/brightness
else
	echo "Error ! You need to ask for 'up' or 'down'"
fi
