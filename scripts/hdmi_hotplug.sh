#!/bin/sh

PREV_STATE=""

while :; do
    STATE=$(xrandr | grep "HDMI-A-0 connected")

    if [ -n "$STATE" ] && [ "$STATE" != "$PREV_STATE" ]; then
		HDMI_PORT=$(xrandr | grep " connected" | grep "HDMI" | cut -d' ' -f1)
		if [ -n "$HDMI_PORT" ]; then
			xrandr --output "$HDMI_PORT" --auto --above eDP
		else
			xrandr --output HDMI-A-0 --auto --above eDP
		fi
		~/.fehbg
        PREV_STATE="$STATE"
    elif [ -z "$STATE" ] && [ -n "$PREV_STATE" ]; then
        xrandr --output HDMI-A-0 --off
		~/.fehbg
        PREV_STATE=""
    fi
    sleep 2
done

