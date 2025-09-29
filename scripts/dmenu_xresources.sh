#!/bin/bash

FILE="/home/thomas/.Xresources"
ELEM=$(printf "fluorite.border_width
fluorite.border_focused
fluorite.border_unfocused
fluorite.gaps
fluorite.stack_offset
fluorite.default_master_offset" | dmenu -b -i -l 9 -p "Property: ") || exit 0
VALUE="$(echo "" | dmenu -b -i -p "Value: " <&-)" || exit 0

if [ "$VALUE" = "!" ]; then
	sed -i "/$ELEM/s/^/! /" $FILE
elif [ "$VALUE" = "?" ]; then
	sed -i "/$ELEM/s/^!//" $FILE
else
sed -i "/$ELEM/c\\
$ELEM: $VALUE
" "$FILE"
fi
