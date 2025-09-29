# DON'T USE IT ! It might causes issues with your WM !
#!/bin/bash

PREV_STATE=""

while :; do
    STATE=$(xrandr | grep "HDMI-A-0 connected")

    if [ -n "$STATE" ] && [ "$STATE" != "$PREV_STATE" ]; then
        xrandr --output HDMI-A-0 --off
		sleep 0.25
		xrandr --output HDMI-A-0 --auto --above eDP
		~/.fehbg
		sleep 3
		~/tools/suckless_tools/scripts/multi_polybar.sh
        PREV_STATE="$STATE"
    elif [ -z "$STATE" ] && [ -n "$PREV_STATE" ]; then
        xrandr --output HDMI-A-0 --off
		~/.fehbg
		sleep 3
		~/tools/suckless_tools/scripts/multi_polybar.sh
        PREV_STATE=""
    fi
    sleep 2
done

