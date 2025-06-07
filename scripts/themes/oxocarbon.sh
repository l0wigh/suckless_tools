#!/bin/bash

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
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #42be65' /tmp/Xresources_switcher

# Neovim
cp ~/.config/nvim/lua/oxocarbon ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "oxocarbon"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0x42be65'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x262626' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x262626'   /tmp/Xresources_switcher

# Dunst
cp ~/.config/dunst/oxocarbon ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/9x8_2.jpg
