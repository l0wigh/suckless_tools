#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #161616' /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #e87a90' /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #7ea95e' /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #d8a07d' /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #82a0c2' /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #b491c3' /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #72a9a9' /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #c0b7b1' /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #313131' /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #ef97a8' /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #98bc83' /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #e3b89e' /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #a1b7d1' /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #c9b0d5' /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #90c0c0' /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #e8e3e0' /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #b491c3' /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=dark")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("sakura")' ~/.config/nvim/lua/theme.lua


# Helix
sed -i '/theme =/c\theme = "sakura"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Tokyo Night Storm",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/sakura.png
