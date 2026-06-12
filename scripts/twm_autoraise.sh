#!/bin/sh
while true; do
  WIN=$(xdotool getmouselocation --shell 2>/dev/null | grep '^WINDOW=' | cut -d= -f2)
  if [ -n "$WIN" ] && [ "$WIN" != "0" ]; then
    xdotool windowraise "$WIN" 2>/dev/null
  fi
  sleep 0.15
done &
