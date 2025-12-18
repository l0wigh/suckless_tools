#!/bin/bash

cp ~/.Xresources /tmp/Xresources_switcher
COUNT=4

SELECTED=$(printf "gruvbox
iceberg
rosepine
oxocarbon
catppuccin
vscode
tokyonight-storm
edge-light
solarized-light
melange-light" | dmenu -c -l $COUNT -p "Theme: ") || exit 0

$HOME/tools/suckless_tools/scripts/themes/$SELECTED.sh

# cp ~/.config/polybar/$SELECTED.ini ~/.config/polybar/theme.ini

# Reload dunst (NEEDS a fix)
# killall -q dunst
# while pgrep -x dunst > /dev/null; do sleep 0.1; done
# dunst \
# 	-cb "$(xrdb -query | grep st.color0: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" \
# 	-nb "$(xrdb -query | grep st.color0: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" \
# 	-lb "$(xrdb -query | grep st.color0: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" \
# 	-cf "$(xrdb -query | grep st.color1: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" \
# 	-nf "$(xrdb -query | grep st.color4: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" \
# 	-lf "$(xrdb -query | grep st.color3: | cut -d ':' -f 2 | awk '{$1=$1};1' | tr -d '\n')" &

# Reload St and nvim
pidof nvim | xargs kill -s USR1
pidof hx | xargs kill -s USR1
pidof tabbed | xargs kill -s USR1
sleep 0.1
pidof st | xargs kill -s USR1
$HOME/tools/suckless_tools/scripts/multi_polybar.sh
