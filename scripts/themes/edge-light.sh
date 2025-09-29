#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #FAFAFA'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #D05858'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #608E32'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #BE7E05'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #5079BE'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #B05CCC'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #3A8B84'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #8790A0'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #4B505B'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #D05858'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #608E32'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #BE7E05'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #5079BE'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #B05CCC'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #3A8B84'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #8790A0'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #BE7E05'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=light")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("edge")' ~/.config/nvim/lua/theme.lua

# Zed Editor
sed -i '/"light":/c\"light": "One Light",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/edge-light.jpg
