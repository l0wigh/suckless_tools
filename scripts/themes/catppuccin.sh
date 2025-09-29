#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #303446'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #E78284'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #A6D189'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #E5C890'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #8CAAEE'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #F4B8E4'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #81C8BE'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #b0b9da'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #626880'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #E78284'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #A6D189'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #E5C890'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #8CAAEE'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #F4B8E4'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #81C8BE'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #A5ADCE'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #8CAAEE'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("catppuccin-frappe")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "catppuccin_frappe"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Catppuccin Frappé",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/catppuccin.jpg
