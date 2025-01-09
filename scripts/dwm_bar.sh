while true;
do
	BATT=$(cat /sys/class/power_supply/BAT0/capacity)
	DATE=$(date +'%R')
	CLUM=$(cat /sys/class/backlight/acpi_video0/brightness)
	MLUM=$(cat /sys/class/backlight/acpi_video0/max_brightness)
	xsetroot -name " [$CLUM/$MLUM] [$BATT%] [$DATE] "
	sleep 3s
done &
