#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #1c1c1c'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #cc241d'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #98971a'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #d79921'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #458588'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #b16286'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #689d6a'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #a89984'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #928374'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #fb4934'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #b8bb26'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #fabd2f'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #83a598'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #d3869b'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #8ec07c'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #ebdbb2'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #458588'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("gruvbox-baby")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "gruvbox_baby"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Gruvbox Dark Hard",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/doom_gruvbox.jpg
