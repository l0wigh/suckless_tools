#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #1d202f'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #f7768e'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #9ece6a'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #e0af68'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #7aa2f7'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #bb9af7'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #7dcfff'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #a9b1d6'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #414868'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #f7768e'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #9ece6a'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #e0af68'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #7aa2f7'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #bb9af7'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #7dcfff'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #c0caf5'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #bb9af7'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("tokyonight-storm")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "tokyonight_storm"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Tokyo Night Storm",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/tokyonight-storm.png
