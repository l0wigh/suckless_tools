#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #191724'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #eb6f92'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #9ccfd8'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #f6c177'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #31748f'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #c4a7e7'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #ebbcba'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #e0def4'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #6e6a86'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #eb6f92'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #9ccfd8'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #f6c177'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #31748f'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #c4a7e7'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #ebbcba'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #e0def4'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #ff7eb6'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("rose-pine")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "rose_pine"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Rosé Pine",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/new_rosepine.jpg
