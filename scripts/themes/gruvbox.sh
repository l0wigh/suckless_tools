#!/bin/bash
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
sed -i.bak '/dmenu.normfgcolor:/c\dmenu.normfgcolor: #888888' /tmp/Xresources_switcher
sed -i.bak '/dmenu.selbgcolor:/c\dmenu.selbgcolor: #458588' /tmp/Xresources_switcher

# Neovim
cp ~/.config/nvim/lua/gruvbox ~/.config/nvim/lua/theme.lua

# Helix
sed -i.bak '/theme =/c\theme = "gruvbox_baby"' ~/.config/helix/config.toml

# Fluorite
sed -i.bak '/fluorite.border_focused/c\fluorite.border_focused: 0x458588'     /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_unfocused/c\fluorite.border_unfocused: 0x665c54' /tmp/Xresources_switcher
sed -i.bak '/fluorite.border_inactive/c\fluorite.border_inactive: 0x665c54'   /tmp/Xresources_switcher

# Dunst
cp ~/.config/dunst/gruvbox ~/.config/dunst/dunstrc

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/doom_gruvbox.jpg
