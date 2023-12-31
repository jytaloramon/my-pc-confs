#!/bin/bash

CURRENT_PLAYER=$(playerctl-current-player.sh)

if [[ -z $CURRENT_PLAYER ]]; then
    exit 0
fi


case $1 in
    all) playerctl -a pause;;

    *) playerctl --player=$CURRENT_PLAYER play-pause;;
esac
