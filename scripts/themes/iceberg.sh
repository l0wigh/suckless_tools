#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #161821'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #e27878'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #b4be82'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #e2a478'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #84a0c6'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #a093c7'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #89b8c2'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #c6c8d1'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #6b7089'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #e98989'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #c0ca8e'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #e9b189'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #91acd1'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #ada0d3'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #95c4ce'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #d2d4de'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #e27878'  /tmp/Xresources_switcher
	
# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("iceberg")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "iceberg-dark"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Iceberg",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/p14sgen4_offset.png
