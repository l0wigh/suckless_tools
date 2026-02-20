#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #151515'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #bf616a'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #a3be8c'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #ebcb8b'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #81a1c1'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #b48ead'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #88c0d0'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #d8dee9'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #505050'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #bf616a'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #a3be8c'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #ebcb8b'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #81a1c1'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #b48ead'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #88c0d0'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #ffffff'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #a3be8c'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("cursor-dark")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "fleet_dark"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "VScode Dark Plus",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/cursor-test.jpg
