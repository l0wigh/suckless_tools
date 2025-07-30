#!/bin/bash

# Polybar
cp ~/.config/polybar/solarized-light.ini ~/.config/polybar/config.ini
killall polybar && polybar &

# St colors
sed -i.bak '/st.color0:/c\st.color0:   #fdf6e3'  /tmp/Xresources_switcher
sed -i.bak '/st.color1:/c\st.color1:   #dc322f'  /tmp/Xresources_switcher
sed -i.bak '/st.color2:/c\st.color2:   #859900'  /tmp/Xresources_switcher
sed -i.bak '/st.color3:/c\st.color3:   #b58900'  /tmp/Xresources_switcher
sed -i.bak '/st.color4:/c\st.color4:   #d33682'  /tmp/Xresources_switcher
sed -i.bak '/st.color5:/c\st.color5:   #7377c5'  /tmp/Xresources_switcher
sed -i.bak '/st.color6:/c\st.color6:   #2aa198'  /tmp/Xresources_switcher
sed -i.bak '/st.color7:/c\st.color7:   #98a5a4'  /tmp/Xresources_switcher
sed -i.bak '/st.color8:/c\st.color8:   #98a5a4'  /tmp/Xresources_switcher
sed -i.bak '/st.color9:/c\st.color9:   #cd5320'  /tmp/Xresources_switcher
sed -i.bak '/st.color10:/c\st.color10: #859900'  /tmp/Xresources_switcher
sed -i.bak '/st.color11:/c\st.color11: #b48b08'  /tmp/Xresources_switcher
sed -i.bak '/st.color12:/c\st.color12: #3090d2'  /tmp/Xresources_switcher
sed -i.bak '/st.color13:/c\st.color13: #dd3b38'  /tmp/Xresources_switcher
sed -i.bak '/st.color14:/c\st.color14: #8b9d0b'  /tmp/Xresources_switcher
sed -i.bak '/st.color15:/c\st.color15: #98a5a4'  /tmp/Xresources_switcher

# dmenu colors
sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #eee8d5' /tmp/Xresources_switcher
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #d2312e' /tmp/Xresources_switcher

# Neovim
cp ~/.config/nvim/lua/solarized-light ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "solarized_light"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0xd2312e'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x98a5a4' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0xeee8d5'   /tmp/Xresources_switcher

# Zed Editor
sed -i.bak '/"light":/c\"light": "NeoSolarized Light",' ~/.config/zed/settings.json

# Dunst
cp ~/.config/dunst/solarized-light ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/solarized-light.jpg
