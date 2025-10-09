#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #1f1f1f'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #f44747'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #608b4e'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #dcdcaa'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #569cd6'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #c678dd'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #56b6c2'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #d4d4d4'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #808080'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #f44747'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #608b4e'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #dcdcaa'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #569cd6'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #c678dd'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #56b6c2'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #d4d4d4'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #c678dd'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("vscode")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "dark_plus"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "VScode Dark Plus",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/vscode.jpg
