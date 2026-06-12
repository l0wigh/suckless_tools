WM=$(
printf "Fluorite
TWM" | dmenu -b -i -l 10 -p "Window Manager: ") || exit 0
if [ "$WM" = "Fluorite" ]; then
	cp ~/.fluorite_xinitrc ~/.xinitrc
elif [ "$WM" = "TWM" ]; then
	cp ~/.twm_xinitrc ~/.xinitrc
fi
