#!/bin/bash

COMMAND=$(printf "Fluorite Settings
Theme Selector
Polybar Selector
Color Picker
Font Picker
Notepad
Quick SSH
Power Menu
Copy selected window WM_CLASS
Kill selected window" | dmenu -i -c -l 5 -p "Command Palette: ") || exit 0

case "$COMMAND" in
    "Fluorite Settings")            st -e fish -c 'nv ~/.config/fluorite/fluorite.conf' ;;
    "Theme Selector")               ~/tools/suckless_tools/scripts/fluorite_theme.sh ;;
    "Polybar Selector")             ~/tools/suckless_tools/scripts/dmenu_polybar_style.sh ;;
    "Color Picker")                 ~/tools/suckless_tools/scripts/colorpicker.sh ;;
    "Font Picker")                  ~/tools/suckless_tools/scripts/st_font.sh font ;;
    "Quick SSH")                    ~/tools/suckless_tools/scripts/quick_ssh.sh ~/notes/ssh.qk ;;
    "Notepad")                      st -n "force_float" -e fish -c 'red' ;;
    "Power Menu")                   ~/tools/suckless_tools/scripts/dmenu_power.sh ;;
    "Copy selected window WM_CLASS") xprop WM_CLASS | cut -d ',' -f 2 | tr -d '\n' | tr -d ' ' | copyclip; notify-send -u low "WM_CLASS copied" ;;
    "Kill selected window")         xkill -frame ;;
esac
