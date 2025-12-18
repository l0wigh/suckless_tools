#!/bin/bash

# Global colors
sed -i '/#define c0/c\#define c0 #f1f1f1'  /tmp/Xresources_switcher
sed -i '/#define c1/c\#define c1 #C77B8B'  /tmp/Xresources_switcher
sed -i '/#define c2/c\#define c2 #6E9B72'  /tmp/Xresources_switcher
sed -i '/#define c3/c\#define c3 #BC5C00'  /tmp/Xresources_switcher
sed -i '/#define c4/c\#define c4 #7892BD'  /tmp/Xresources_switcher
sed -i '/#define c5/c\#define c5 #BE79BB'  /tmp/Xresources_switcher
sed -i '/#define c6/c\#define c6 #739797'  /tmp/Xresources_switcher
sed -i '/#define c7/c\#define c7 #7D6658'  /tmp/Xresources_switcher
sed -i '/#define c8/c\#define c8 #A98A78'  /tmp/Xresources_switcher
sed -i '/#define c9/c\#define c9 #BF0021'  /tmp/Xresources_switcher
sed -i '/#define ca/c\#define ca #3A684A'  /tmp/Xresources_switcher
sed -i '/#define cb/c\#define cb #A06D00'  /tmp/Xresources_switcher
sed -i '/#define cc/c\#define cc #465AA4'  /tmp/Xresources_switcher
sed -i '/#define cd/c\#define cd #904180'  /tmp/Xresources_switcher
sed -i '/#define ce/c\#define ce #3D6568'  /tmp/Xresources_switcher
sed -i '/#define cf/c\#define cf #54433A'  /tmp/Xresources_switcher
sed -i '/#define pr/c\#define pr #465AA4'  /tmp/Xresources_switcher

# Neovim
sed -i '/vim.cmd("set/c\vim.cmd("set background=light")' ~/.config/nvim/lua/theme.lua
sed -i '/vim.cmd.color/c\vim.cmd.colorscheme("melange")' ~/.config/nvim/lua/theme.lua

# Helix
sed -i '/theme =/c\theme = "catppuccin_frappe"' ~/.config/helix/config.toml

# Zed Editor
sed -i '/"light":/c\"light": "Catppuccin Frappé",' ~/.config/zed/settings.json

# Apply modifications
cp /tmp/Xresources_switcher ~/.Xresources

# Background
feh --bg-fill ~/wallpapers/melange-new.jpg
