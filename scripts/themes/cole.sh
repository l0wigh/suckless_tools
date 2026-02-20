#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #101010' /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #cc5d4b' /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #2e9969' /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #b38d59' /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #6179c2' /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #ab78ab' /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #33919c' /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #a5a5a5' /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #3d3d3d' /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #d96857' /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #66cc69' /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #cc9b52' /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #5582c2' /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #bf86bf' /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #73bfbf' /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #cdcdcd' /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #2e9969' /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("cole")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "dark_plus"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "VScode Dark Plus",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/cole-2.jpg
