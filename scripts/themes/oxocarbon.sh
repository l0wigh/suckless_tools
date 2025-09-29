#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #161616'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #33b1ff'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #be95ff'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #42be65'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #78a9ff'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #82cfff'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #3ddbd9'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #f2f4f8'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #525252'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #33b1ff'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #be95ff'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #42be65'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #78a9ff'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #82cfff'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #08bdba'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #ffffff'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #42be65'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("oxocarbon")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "oxocarbon"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Oxocarbon Dark (IBM Carbon)",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/9x8_2.jpg
