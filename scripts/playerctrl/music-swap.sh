#!/bin/bash

CURRENT_PLAYER=$(~/.config/scripts/playerctrl/current-player.sh)

if [[ -z $CURRENT_PLAYER ]]; then
    exit 0
fi

case $1 in
    previous) playerctl --player=$CURRENT_PLAYER previous;;
    
    next) playerctl --player=$CURRENT_PLAYER next;;
    
    *) exit 0;;
esac
