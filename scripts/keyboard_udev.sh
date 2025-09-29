#!/bin/bash

export DISPLAY=":0"

# Mise en français et réglage vitesse répétition touches
su - thomas -c "setxkbmap fr"
su - thomas -c "xset r rate 300 50"

logger "Configuration clavier appliquée"
