#!/bin/bash
ACTION=$1
WS=$2
PROP="_TWM_WS"
REGISTRY="/tmp/.twm_registry"

# --- Helpers ---

register()   { touch "$REGISTRY"; grep -qxF "$1" "$REGISTRY" || echo "$1" >> "$REGISTRY"; }
unregister() { [ -f "$REGISTRY" ] && sed -i "/^$1$/d" "$REGISTRY"; }
win_alive()  { xprop -id "$1" WM_CLASS &>/dev/null; }

get_all_windows() {
	{
		xprop -root _NET_CLIENT_LIST 2>/dev/null | grep -o '0x[0-9a-f]\+'
		[ -f "$REGISTRY" ] && cat "$REGISTRY"
	} | sort -u | while read -r id; do
# Nettoie automatiquement les fenêtres fermées du registre
if win_alive "$id"; then
	echo "$id"
else
	unregister "$id"
fi
done
}

# --- Actions ---

case $ACTION in
	"init")
		rm -f "$REGISTRY"
		xprop -root -f _NET_NUMBER_OF_DESKTOPS 32c -set _NET_NUMBER_OF_DESKTOPS 10
		xprop -root -f _NET_CURRENT_DESKTOP   32c -set _NET_CURRENT_DESKTOP   0
		;;

	"send")
		WID=$(xdotool getmouselocation --shell | grep WINDOW | cut -d= -f2)
		if [ "$WID" != "0" ] && win_alive "$WID"; then
			xprop -id "$WID" -f $PROP 32c -set $PROP "$WS"
			register "$WID"
			# Récupère le workspace courant (1-indexed)
			CUR_IDX=$(xprop -root _NET_CURRENT_DESKTOP | grep -o '[0-9]\+')
			CUR_WS=$((CUR_IDX + 1))
			if [ "$WS" -ne "$CUR_WS" ]; then
				xdotool windowunmap "$WID"
			fi
		fi
		;;

	"untag")
		WID=$(xdotool getmouselocation --shell | grep WINDOW | cut -d= -f2)
		if [ "$WID" != "0" ] && win_alive "$WID"; then
			xprop -id "$WID" -remove $PROP
			xdotool windowmap "$WID"
			unregister "$WID"
		fi
		;;

	"view")
		CUR_IDX=$((WS - 1))
		xprop -root -f _NET_CURRENT_DESKTOP 32c -set _NET_CURRENT_DESKTOP $CUR_IDX

		for id in $(get_all_windows); do
			current_tag=$(xprop -id "$id" $PROP 2>/dev/null | grep -o '[0-9]\+')
			if [ -n "$current_tag" ]; then
				if [ "$current_tag" -eq "$WS" ]; then
					xdotool windowmap   "$id"
					xdotool windowraise "$id"
				else
					xdotool windowunmap "$id"
				fi
			else
				# Sticky : pas de tag = toujours visible
				xdotool windowmap "$id" 2>/dev/null
			fi
		done
		;;
esac
