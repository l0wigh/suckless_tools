#!/bin/bash

XRANDR_OUTPUT=$(xrandr)

HDMI_BLOCK=$(echo "$XRANDR_OUTPUT" | sed -n '/HDMI-A-0 connected/,/^[A-Za-z]/p')

declare -a OPTIONS_ARRAY

while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*([0-9]+x[0-9]+) ]]; then
        RESOLUTION="${BASH_REMATCH[1]}"
        REFRESH_RATES=$(echo "$line" | grep -oP '[0-9]+\.[0-9]+(?=\*|\+)?')
        
        for rate in $REFRESH_RATES; do
            CLEAN_RATE=$(echo "$rate" | sed 's/[*+]//g' | cut -d'.' -f1)
            OPTIONS_ARRAY+=("${RESOLUTION} ${CLEAN_RATE}")
        done
    fi
done <<< "$HDMI_BLOCK"

SORTED_OPTIONS=$(printf "%s\n" "${OPTIONS_ARRAY[@]}" | \
    awk '{
        split($1, res, "x");
        print res[1], res[2], $2, $0
    }' | sort -nr -k1 -k2 -k3 | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//')

FINAL_OPTIONS=$(printf "%s\nunplug" "${SORTED_OPTIONS}")

OPT=$(printf "%s" "${FINAL_OPTIONS}" | dmenu -c -l 10 -p "HDMI-A-0: ") || exit 0

if [ "$OPT" = "unplug" ]; then
	xrandr --output HDMI-A-0 --off
	~/.fehbg
	sleep 3
	~/tools/suckless_tools/scripts/multi_polybar.sh
	notify-send -u low "Deactivate HDMI-A-0"
else
	SELECTED_RESOLUTION=$(echo "$OPT" | awk '{print $1}')
	SELECTED_RATE=$(echo "$OPT" | awk '{print $2}')
	xrandr --output HDMI-A-0 --mode "${SELECTED_RESOLUTION}" --rate "${SELECTED_RATE}" --above eDP
	~/.fehbg
	sleep 3
	~/tools/suckless_tools/scripts/multi_polybar.sh
	notify-send -u low "Activate HDMI-A-0 with ${SELECTED_RESOLUTION} @ ${SELECTED_RATE}Hz"
fi
