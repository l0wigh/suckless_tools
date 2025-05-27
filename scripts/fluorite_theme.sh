#!/bin/bash

cp ~/.Xresources /tmp/Xresources_switcher
COUNT=4

SELECTED=$(printf "gruvbox
iceberg
rose pine
oxocarbon" | dmenu -c -l $COUNT -p "Theme: ") || exit 0

if [ "$SELECTED" = "gruvbox" ]; then
	# Polybar
	cp ~/.config/polybar/gruvbox.ini ~/.config/polybar/config.ini
	killall polybar && polybar &

	# St colors
	sed -i.bak '/st.color0:/c\st.color0:  #1c1c1c'  /tmp/Xresources_switcher
	sed -i.bak '/st.color1:/c\st.color1:  #cc241d'  /tmp/Xresources_switcher
	sed -i.bak '/st.color2:/c\st.color2:  #98971a'  /tmp/Xresources_switcher
	sed -i.bak '/st.color3:/c\st.color3:  #d79921'  /tmp/Xresources_switcher
	sed -i.bak '/st.color4:/c\st.color4:  #458588'  /tmp/Xresources_switcher
	sed -i.bak '/st.color5:/c\st.color5:  #b16286'  /tmp/Xresources_switcher
	sed -i.bak '/st.color6:/c\st.color6:  #689d6a'  /tmp/Xresources_switcher
	sed -i.bak '/st.color7:/c\st.color7:  #a89984'  /tmp/Xresources_switcher
	sed -i.bak '/st.color8:/c\st.color8:  #928374'  /tmp/Xresources_switcher
	sed -i.bak '/st.color9:/c\st.color9:  #fb4934'  /tmp/Xresources_switcher
	sed -i.bak '/st.color10:/c\st.color10: #b8bb26' /tmp/Xresources_switcher
	sed -i.bak '/st.color11:/c\st.color11: #fabd2f' /tmp/Xresources_switcher
	sed -i.bak '/st.color12:/c\st.color12: #83a598' /tmp/Xresources_switcher
	sed -i.bak '/st.color13:/c\st.color13: #d3869b' /tmp/Xresources_switcher
	sed -i.bak '/st.color14:/c\st.color14: #8ec07c' /tmp/Xresources_switcher
	sed -i.bak '/st.color15:/c\st.color15: #ebdbb2' /tmp/Xresources_switcher

	# dmenu colors
	sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #1c1c1c' /tmp/Xresources_switcher
	sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #458588' /tmp/Xresources_switcher

	# Neovim
	cp ~/.config/nvim/lua/gruvbox ~/.config/nvim/lua/theme.lua

	# Fluorite
	sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0x458588'     /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x665c54' /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x665c54'   /tmp/Xresources_switcher

	# Apply modifications
	cp /tmp/Xresources_switcher ~/.Xresources

	# Background
	feh --bg-fill ~/wallpapers/doom_gruvbox.jpg
elif [ "$SELECTED" = "iceberg" ]; then
	# Polybar
	cp ~/.config/polybar/iceberg.ini ~/.config/polybar/config.ini
	killall polybar && polybar &

	# St colors
	sed -i.bak '/st.color0:/c\st.color0:  #161821'  /tmp/Xresources_switcher
	sed -i.bak '/st.color1:/c\st.color1:  #e27878'  /tmp/Xresources_switcher
	sed -i.bak '/st.color2:/c\st.color2:  #b4be82'  /tmp/Xresources_switcher
	sed -i.bak '/st.color3:/c\st.color3:  #e2a478'  /tmp/Xresources_switcher
	sed -i.bak '/st.color4:/c\st.color4:  #84a0c6'  /tmp/Xresources_switcher
	sed -i.bak '/st.color5:/c\st.color5:  #a093c7'  /tmp/Xresources_switcher
	sed -i.bak '/st.color6:/c\st.color6:  #89b8c2'  /tmp/Xresources_switcher
	sed -i.bak '/st.color7:/c\st.color7:  #c6c8d1'  /tmp/Xresources_switcher
	sed -i.bak '/st.color8:/c\st.color8:  #6b7089'  /tmp/Xresources_switcher
	sed -i.bak '/st.color9:/c\st.color9:  #e98989'  /tmp/Xresources_switcher
	sed -i.bak '/st.color10:/c\st.color10: #c0ca8e' /tmp/Xresources_switcher
	sed -i.bak '/st.color11:/c\st.color11: #e9b189' /tmp/Xresources_switcher
	sed -i.bak '/st.color12:/c\st.color12: #91acd1' /tmp/Xresources_switcher
	sed -i.bak '/st.color13:/c\st.color13: #ada0d3' /tmp/Xresources_switcher
	sed -i.bak '/st.color14:/c\st.color14: #95c4ce' /tmp/Xresources_switcher
	sed -i.bak '/st.color15:/c\st.color15: #d2d4de' /tmp/Xresources_switcher

	# dmenu colors
	sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #161821' /tmp/Xresources_switcher
	sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #e27878' /tmp/Xresources_switcher
	
	# Neovim
	cp ~/.config/nvim/lua/iceberg ~/.config/nvim/lua/theme.lua

	# Fluorite
	sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xe27878'     /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x1e1e1e' /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x1e1e1e'   /tmp/Xresources_switcher

	# Apply modifications
	cp /tmp/Xresources_switcher ~/.Xresources

	# Background
	feh --bg-fill ~/wallpapers/p14sgen4_offset.png
elif [ "$SELECTED" = "rose pine" ]; then
	# Polybar
	cp ~/.config/polybar/rosepine.ini ~/.config/polybar/config.ini
	killall polybar && polybar &

	# St colors
	sed -i.bak '/st.color0:/c\st.color0:   #191724'  /tmp/Xresources_switcher
	sed -i.bak '/st.color1:/c\st.color1:   #eb6f92'  /tmp/Xresources_switcher
	sed -i.bak '/st.color2:/c\st.color2:   #9ccfd8'  /tmp/Xresources_switcher
	sed -i.bak '/st.color3:/c\st.color3:   #f6c177'  /tmp/Xresources_switcher
	sed -i.bak '/st.color4:/c\st.color4:   #31748f'  /tmp/Xresources_switcher
	sed -i.bak '/st.color5:/c\st.color5:   #c4a7e7'  /tmp/Xresources_switcher
	sed -i.bak '/st.color6:/c\st.color6:   #ebbcba'  /tmp/Xresources_switcher
	sed -i.bak '/st.color7:/c\st.color7:   #e0def4'  /tmp/Xresources_switcher
	sed -i.bak '/st.color8:/c\st.color8:   #6e6a86'  /tmp/Xresources_switcher
	sed -i.bak '/st.color9:/c\st.color9:   #eb6f92'  /tmp/Xresources_switcher
	sed -i.bak '/st.color10:/c\st.color10: #9ccfd8'  /tmp/Xresources_switcher
	sed -i.bak '/st.color11:/c\st.color11: #f6c177'  /tmp/Xresources_switcher
	sed -i.bak '/st.color12:/c\st.color12: #31748f'  /tmp/Xresources_switcher
	sed -i.bak '/st.color13:/c\st.color13: #c4a7e7'  /tmp/Xresources_switcher
	sed -i.bak '/st.color14:/c\st.color14: #ebbcba'  /tmp/Xresources_switcher
	sed -i.bak '/st.color15:/c\st.color15: #e0def4'  /tmp/Xresources_switcher

	# dmenu colors
	sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #191724' /tmp/Xresources_switcher
	sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #ff7eb6' /tmp/Xresources_switcher
	
	# Neovim
	cp ~/.config/nvim/lua/rosepine ~/.config/nvim/lua/theme.lua

	# Fluorite
	sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xeb6f92'     /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x524f67' /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x21202e'   /tmp/Xresources_switcher

	# Apply modifications
	cp /tmp/Xresources_switcher ~/.Xresources

	# Background
	feh --bg-fill ~/wallpapers/rosepine_test.png
elif [ $SELECTED = "oxocarbon" ]; then
	# Polybar
	cp ~/.config/polybar/oxocarbon.ini ~/.config/polybar/config.ini
	killall polybar && polybar &

	# St colors
	sed -i.bak '/st.color0:/c\st.color0:   #161616'  /tmp/Xresources_switcher
	sed -i.bak '/st.color1:/c\st.color1:   #33b1ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color2:/c\st.color2:   #be95ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color3:/c\st.color3:   #42be65'  /tmp/Xresources_switcher
	sed -i.bak '/st.color4:/c\st.color4:   #78a9ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color5:/c\st.color5:   #82cfff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color6:/c\st.color6:   #3ddbd9'  /tmp/Xresources_switcher
	sed -i.bak '/st.color7:/c\st.color7:   #f2f4f8'  /tmp/Xresources_switcher
	sed -i.bak '/st.color8:/c\st.color8:   #525252'  /tmp/Xresources_switcher
	sed -i.bak '/st.color9:/c\st.color9:   #33b1ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color10:/c\st.color10: #be95ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color11:/c\st.color11: #42be65'  /tmp/Xresources_switcher
	sed -i.bak '/st.color12:/c\st.color12: #78a9ff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color13:/c\st.color13: #82cfff'  /tmp/Xresources_switcher
	sed -i.bak '/st.color14:/c\st.color14: #08bdba'  /tmp/Xresources_switcher
	sed -i.bak '/st.color15:/c\st.color15: #ffffff'  /tmp/Xresources_switcher

	# dmenu colors
	sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #161616' /tmp/Xresources_switcher
	sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #42be65' /tmp/Xresources_switcher

	# Neovim
	cp ~/.config/nvim/lua/oxocarbon ~/.config/nvim/lua/theme.lua

	# Fluorite
	sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0x42be65'     /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x161616' /tmp/Xresources_switcher
	sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x060606'   /tmp/Xresources_switcher

	# Apply modifications
	cp /tmp/Xresources_switcher ~/.Xresources

	# Background
	feh --bg-fill ~/wallpapers/9x8_2.jpg
else
	notify-send "No theme selected"
fi	

# Reload St and nvim
pidof nvim | xargs kill -s USR1
pidof st | xargs kill -s USR1
