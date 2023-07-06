#!/bin/bash

CURRENT_PLAYER=$(~/.config/scripts/playerctrl/current-player.sh)
LEVEL=0.1

if [[ -z $CURRENT_PLAYER ]]; then
    exit 0
fi

case $1 in
    down) playerctl --player=$CURRENT_PLAYER volume $LEVEL-;;

    up) playerctl --player=$CURRENT_PLAYER volume $LEVEL+;;

    *) exit 0;;
esac
