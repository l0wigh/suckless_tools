#!/bin/sh
# Verrouille l'écran et coupe le rétroéclairage (DPMS)
(sleep 0.5 && xset dpms force off) &
exec elogind-inhibit --what=sleep xsecurelock
