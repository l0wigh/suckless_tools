#!/bin/bash

udevadm monitor -u -s input | while read -r line; do
    if echo "$line" | grep -q "add"; then
        xset r rate 300 50
    fi
done
