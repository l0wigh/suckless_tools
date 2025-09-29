# Configuration of keyboard and screen
setxkbmap fr &
xset r rate 300 50 &
xrdb -merge ~/.Xresources
xrandr --output eDP --primary
xrandr --output HDMI-A-0 --auto --above eDP
brightnessctl set 100% &

# Transparency, background, notification, bar, java fix
picom &
~/.fehbg &
dunst &
polybar &
~/tools/suckless_tools/scripts/multi_polybar.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export XSECURELOCK_COMPOSITE_OBSCURER=0

# battery checker
/home/thomas/tools/suckless_tools/scripts/battery_checker.py &

# No more need to physically click the touchpad
# synclient TapButton1=1
# synclient TapButton2=3
# synclient TapButton3=2

# Fluorite installed
exec Fluorite
# EVO2 Pre-release
exec /home/thomas/tools/Fluorite_Evo2/Fluorite 2> ~/.fluorite.log
