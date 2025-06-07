#!/bin/bash

# Polybar
cp ~/.config/polybar/edge-light.ini ~/.config/polybar/config.ini
killall polybar && polybar &

# St colors
sed -i.bak '/st.color0:/c\st.color0:   #FAFAFA'  /tmp/Xresources_switcher
sed -i.bak '/st.color1:/c\st.color1:   #D05858'  /tmp/Xresources_switcher
sed -i.bak '/st.color2:/c\st.color2:   #608E32'  /tmp/Xresources_switcher
sed -i.bak '/st.color3:/c\st.color3:   #BE7E05'  /tmp/Xresources_switcher
sed -i.bak '/st.color4:/c\st.color4:   #5079BE'  /tmp/Xresources_switcher
sed -i.bak '/st.color5:/c\st.color5:   #B05CCC'  /tmp/Xresources_switcher
sed -i.bak '/st.color6:/c\st.color6:   #3A8B84'  /tmp/Xresources_switcher
sed -i.bak '/st.color7:/c\st.color7:   #8790A0'  /tmp/Xresources_switcher
sed -i.bak '/st.color8:/c\st.color8:   #4B505B'  /tmp/Xresources_switcher
sed -i.bak '/st.color9:/c\st.color9:   #D05858'  /tmp/Xresources_switcher
sed -i.bak '/st.color10:/c\st.color10: #608E32'  /tmp/Xresources_switcher
sed -i.bak '/st.color11:/c\st.color11: #BE7E05'  /tmp/Xresources_switcher
sed -i.bak '/st.color12:/c\st.color12: #5079BE'  /tmp/Xresources_switcher
sed -i.bak '/st.color13:/c\st.color13: #B05CCC'  /tmp/Xresources_switcher
sed -i.bak '/st.color14:/c\st.color14: #3A8B84'  /tmp/Xresources_switcher
sed -i.bak '/st.color15:/c\st.color15: #8790A0'  /tmp/Xresources_switcher

# dmenu colors
sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #FAFAFA' /tmp/Xresources_switcher
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #BE7E05' /tmp/Xresources_switcher

# Neovim
cp ~/.config/nvim/lua/edge-light ~/.config/nvim/lua/theme.lua

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xBE7E05'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x8790A0' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x4B505B'   /tmp/Xresources_switcher

# Dunst
cp ~/.config/dunst/edge-light ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/edge-light.jpg
