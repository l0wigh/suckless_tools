#!/bin/env python3

import os
import time

critical = False
full = False
charging = False

while True:
    for line in open("/sys/class/power_supply/BAT0/capacity"):
        value = int(line)
    for line in open("/sys/class/power_supply/BAT0/status"):
        if line[0:3] == "Dis":
            charging = False
        else:
            charging = True

    if value < 10:
        if critical is False:
            os.system("notify-send -u critical \"Battery under 10% !\"")
            critical = True
            full = False
    if value > 95:
        if full is False and charging:
            os.system("notify-send -u low \"Battery is charged !\"")
            full = True

    if value >= 10 and critical:
        critical = False
    if value <= 95 and full and not charging:
        full = False

    time.sleep(120)
