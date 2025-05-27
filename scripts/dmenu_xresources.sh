#!/bin/bash

FILE="/home/thomas/.Xresources"
ELEM=$(printf "fluorite.border_width
fluorite.border_focused
fluorite.border_unfocused
fluorite.border_inactive
fluorite.gaps
fluorite.stack_offset
fluorite.topbar_gaps
fluorite.bottombar_gaps
fluorite.default_master_offset" | dmenu -b -i -l 9 -p "Property: ") || exit 0
VALUE="$(echo "" | dmenu -b -i -p "Value: " <&-)" || exit 0

if [ "$VALUE" = "!" ]; then
	sed -i.bak "/$ELEM/s/^/! /" $FILE
elif [ "$VALUE" = "?" ]; then
	sed -i.bak "/$ELEM/s/^!//" $FILE
else
sed -i.bak "/$ELEM/c\\
$ELEM: $VALUE
" "$FILE"
fi
