#!/bin/bash

COLORS=$(xrdb -query)
get_color() {
  echo "$COLORS" | grep "\*\.$1:" | cut -d ':' -f 2 | xargs
}

CONFIG_DIR=~/.config/dunst
CONFIG_TEMPLATE="$CONFIG_DIR/dunstrc.template"
CONFIG_FINAL="$CONFIG_DIR/dunstrc"

# Génère dunstrc à partir du template avec envsubst
export C0=$(get_color "color0")
export C1=$(get_color "color1")
export C3=$(get_color "color3")
export C4=$(get_color "color4")
export C7=$(get_color "color7")

envsubst < "$CONFIG_TEMPLATE" > "$CONFIG_FINAL"

killall -q dunst
while pgrep -x dunst > /dev/null; do sleep 0.1; done

dunst &
