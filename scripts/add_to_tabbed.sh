#!/bin/bash
SELECTED_WINDOW=$(xwininfo -id $(xdotool getwindowfocus) | grep "Window id:" | cut -d ":" -f 3 | cut -d " " -f 2)
xdotool windowreparent $SELECTED_WINDOW $(cat /tmp/tabbed.xid)
