#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #fdf6e3'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #dc322f'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #859900'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #b58900'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #d33682'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #7377c5'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #2aa198'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #98a5a4'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #98a5a4'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #cd5320'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #859900'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #b48b08'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #3090d2'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #dd3b38'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #8b9d0b'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #98a5a4'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #dc322f'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=light")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("solarized")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "solarized_light"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "NeoSolarized Light",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/solarized-light.jpg
