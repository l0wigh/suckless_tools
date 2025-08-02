#!/bin/bash

fullfont() {
	FILE="/home/thomas/.Xresources"

	FONT=$(printf "Misc Tamsyn
Tamzen
Dina
VictorMono Nerd Font
DepartureMono Nerd Font
EffectsEighty
ProggyClean Nerd Font
RobotoMono Nerd Font
BlexMono Nerd Font
TempleOS
scientifica
Maple Mono" | dmenu -b -i -l 10 -p "Font Name: ") || exit 0

	SIZE="$(echo "" | dmenu -b -i -p "Size: " <&-)" || exit 0

	if [ "$FONT" = "Tamsyn" ]; then
		ALIAS="false"
	elif [ "$FONT" = "scientifica" ]; then
		ALIAS="false"
	else
		ALIAS="true"
	fi

	REPLACE="$FONT:pixelsize=$SIZE:antialias=$ALIAS:autohint=true"
	sed -i.bak "/st.font:/c\\st.font: $REPLACE" ~/.Xresources
}

fontsize() {
	SIZE="$(echo "" | dmenu -b -i -p "Size: " <&-)" || exit 0
	sed -i "/^st\.font:/ s/pixelsize=[0-9]\+/pixelsize=${SIZE}/" ~/.Xresources
}

if [ "$1" = "font" ]; then
	fullfont
else
	fontsize
fi

xrdb ~/.Xresources
pidof st | xargs kill -s USR1
