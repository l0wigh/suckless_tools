#!/bin/bash

CURR_DATE=$(date '+%Y-%m-%d-%H:%M:%S')

scrot -s -f -F /home/thomas/screenshots/$CURR_DATE.png
