#!/bin/sh

CUR=$(cat /sys/class/backlight/acpi_video0/brightness)

if [[ "$1" == "up" ]]
then
	echo $(( CUR + 1 )) > /sys/class/backlight/acpi_video0/brightness
elif [[ "$1" == "down" ]]
then
	echo $(( CUR - 1 )) > /sys/class/backlight/acpi_video0/brightness
else
	echo "Error ! You need to ask for 'up' or 'down'"
fi
