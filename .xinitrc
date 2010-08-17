#!/bin/bash
 
# Load resources
 
xrdb -merge .Xresources
 
# Set up an icon tray
 
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 7 --tint 000000 --transparent true --height 12 &

# Set the background
# Esetroot -s /home/ishikawa/wallpaper/1245779063369.png
 
# Set Dual Screen Wallpapers
nitrogen --restore &

# Fire up apps

xbindkeys & 
#xscreensaver -no-splash &
 
#if [ -x /usr/bin/wicd-client ] ; then
#   sudo wicd-client &
#fi
 
exec xmonad
