#!/bin/bash

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
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #e27878' /tmp/Xresources_switcher
	
# Neovim
cp ~/.config/nvim/lua/iceberg ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "iceberg-dark"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xe27878'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x1e1e1e' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x1e1e1e'   /tmp/Xresources_switcher

# Zed Editor
sed -i.bak '/"light":/c\"light": "Iceberg",' ~/.config/zed/settings.json

# Dunst
cp ~/.config/dunst/iceberg ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/p14sgen4_offset.png
