#!/bin/bash

### Quick SSH Guide
### Create a file with this format:
### @Name of the SSH
### !ssh command@ip
### %password
### You can add as much entry as you want
### Then call this script while passing the file path as argument
### Is it unsecure ? Yes
### Is it quick ? Yes

SELECTION=$(cat $1 | grep "#" | cut -d '#' -f 2 | awk '{print NR-1 ": " $0}' | dmenu -c -l 3 -p "SSH:") || exit 0
SELECTION=$(echo $SELECTION | cut -d ':' -f 1)
SSH_CMD=$(cat $1 | grep "!" | cut -d '!' -f 2 | sed -n "$((SELECTION + 1))p") 
SSH_PASS=$(cat $1 | grep "%" | cut -d '%' -f 2 | sed -n "$((SELECTION + 1))p")

echo $SSH_PASS | copyclip
st -e fish -c "$SSH_CMD" &
sleep 1
xdotool key ctrl+shift+v
