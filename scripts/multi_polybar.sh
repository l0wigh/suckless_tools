#!/bin/bash

killall -q polybar
while pgrep -x polybar > /dev/null; do sleep 0.1; done

polybar top &
sleep 0.3
polybar dock_primary &
sleep 0.3
polybar dock_hdmi &
