#!/bin/bash
# Polybar
cp ~/.config/polybar/catppuccin.ini ~/.config/polybar/config.ini
killall polybar && polybar &

# St colors
sed -i.bak '/st.color0:/c\st.color0:   #303446'  /tmp/Xresources_switcher
sed -i.bak '/st.color1:/c\st.color1:   #E78284'  /tmp/Xresources_switcher
sed -i.bak '/st.color2:/c\st.color2:   #A6D189'  /tmp/Xresources_switcher
sed -i.bak '/st.color3:/c\st.color3:   #E5C890'  /tmp/Xresources_switcher
sed -i.bak '/st.color4:/c\st.color4:   #8CAAEE'  /tmp/Xresources_switcher
sed -i.bak '/st.color5:/c\st.color5:   #F4B8E4'  /tmp/Xresources_switcher
sed -i.bak '/st.color6:/c\st.color6:   #81C8BE'  /tmp/Xresources_switcher
sed -i.bak '/st.color7:/c\st.color7:   #b0b9da'  /tmp/Xresources_switcher
sed -i.bak '/st.color8:/c\st.color8:   #626880'  /tmp/Xresources_switcher
sed -i.bak '/st.color9:/c\st.color9:   #E78284'  /tmp/Xresources_switcher
sed -i.bak '/st.color10:/c\st.color10: #A6D189' /tmp/Xresources_switcher
sed -i.bak '/st.color11:/c\st.color11: #E5C890' /tmp/Xresources_switcher
sed -i.bak '/st.color12:/c\st.color12: #8CAAEE' /tmp/Xresources_switcher
sed -i.bak '/st.color13:/c\st.color13: #F4B8E4' /tmp/Xresources_switcher
sed -i.bak '/st.color14:/c\st.color14: #81C8BE' /tmp/Xresources_switcher
sed -i.bak '/st.color15:/c\st.color15: #A5ADCE' /tmp/Xresources_switcher

# dmenu colors
sed -i.bak '/dmenu.normbgcolor:/c\dmenu.normbgcolor: #303446' /tmp/Xresources_switcher
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #8CAAEE' /tmp/Xresources_switcher

# Neovim
cp ~/.config/nvim/lua/catppuccin ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "catppuccin_frappe"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0x8CAAEE'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x5c5f77' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x3c3f55'   /tmp/Xresources_switcher

# Dunst
cp ~/.config/dunst/catppuccin ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/catppuccin.jpg
