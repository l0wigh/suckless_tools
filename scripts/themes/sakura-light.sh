#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #f2ecec' /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #df5a75' /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #6a994e' /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #d28e5d' /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #5a7da3' /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #9b6daf' /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #548d8d' /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #5a524c' /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #c8bebe' /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #e87a90' /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #7ea95e' /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #d8a07d' /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #82a0c2' /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #b491c3' /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #72a9a9' /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #4a443e' /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #df5a75' /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=light")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("sakura")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "sakura"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Sakura Light",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/melange-new.jpg

