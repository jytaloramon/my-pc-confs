#!/bin/bash

INTERN=eDP-1
EXTERN=HDMI-1

if [[ $(xrandr | grep "Monitors: 1") ]]; then
    exit 0
fi

if [[ $(xrandr | grep "$EXTERN connected") ]]; then
    xrandr --output $EXTERN --mode 1366x768 --left-of $INTERN
else
    xrandr --output $EXTERN --off --output $INTERN --auto
fi
