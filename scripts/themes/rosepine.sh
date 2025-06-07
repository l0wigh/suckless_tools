#!/bin/bash

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
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #ff7eb6' /tmp/Xresources_switcher
	
# Neovim
cp ~/.config/nvim/lua/rosepine ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "rose_pine"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xeb6f92'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x524f67' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x21202e'   /tmp/Xresources_switcher

# Dunst
cp ~/.config/dunst/rosepine ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/rosepine_test.png
