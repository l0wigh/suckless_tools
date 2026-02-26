# Configuration of keyboard and screen
setxkbmap fr &
xset r rate 300 50 &
xrdb -merge ~/.Xresources
xrandr --output eDP --primary
# xrandr --output HDMI-A-0 --auto --above eDP
# ~/tools/suckless_tools/scripts/hdmi_hotplug.sh &
brightnessctl set 100% &
# brightnessctl set 30% &

# Transparency, background, notification, bar, java fix
picom &
~/.fehbg &
dunst &
# polybar top &
~/tools/suckless_tools/scripts/multi_polybar.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export XSECURELOCK_COMPOSITE_OBSCURER=0
export XDG_CURRENT_DESKTOP="Fluorite [EVO 2]"

# Custom scripts
# play ~/.PS1.mp3 &
/home/thomas/tools/suckless_tools/scripts/battery_checker.py &

# This can sometimes feels good and sometimes be very hard to work with
# synclient TapButton1=1
# synclient TapButton2=3
# synclient TapButton3=2

# exec /home/thomas/tools/ratakor_dwm/dwm
# exec /home/thomas/tools/sxwm_origin/sxwm
# exec /home/thomas/tools/sxwm_fork/sxwm
# exec /home/thomas/tools/ragnar/bin/ragnar
# st
# exec /home/thomas/tools/meow/meow
# exec ragnar
# exec /home/thomas/tools/tinyvvm/tinyvvm

# exec Fluorite 2> ~/.fluorite.log

dbus-launch --exit-with-session /home/thomas/tools/Fluorite_Evo2/Fluorite 2> ~/.fluorite.log
# valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes /home/thomas/tools/Fluorite_Evo2/Fluorite 2> ~/valgrind.log
