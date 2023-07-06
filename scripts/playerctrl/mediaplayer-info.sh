#!/bin/bash

OPT_VOID=0
OPT_GET_TITLE=1
OPT_GET_PLAYER_NAME=2
OPT_GET_TIME=3
OPT_MAX_VALUE=3
CURRENT_OPTION_FILE=~/.config/scripts/playerctrl/current-option.txt

current_player=$(~/.config/scripts/playerctrl/current-player.sh)


if [[ -z $current_player ]]; then
    echo "󰎊"
    exit 0
fi


current_option=$([[ -f $CURRENT_OPTION_FILE ]] && head -n 1 $CURRENT_OPTION_FILE)


save_option(){
    echo -n $current_option > $CURRENT_OPTION_FILE
}

option_decrease(){
    if [[ $current_option -le 0 ]]; then
        current_option=$OPT_MAX_VALUE
    else
        local tmp=$(( $current_option - 1 ))
        current_option=$tmp
    fi
    
    save_option
}

option_increase(){
    if [[ $current_option -ge $OPT_MAX_VALUE ]]; then
        current_option=0
    else
        local tmp=$(( $current_option + 1 ))
        current_option=$tmp
    fi
    
    save_option
}


if [[ -z $current_option ]]; then
    current_option=0
    save_option
fi

case $1 in
    previous) option_decrease;;
    next) option_increase;;
    *) ;;
esac

case $current_option in
    $OPT_GET_TITLE) echo "󰎇 $(playerctl --player=$current_player metadata -f "{{title}}")";;
    $OPT_GET_PLAYER_NAME) echo "󰎇 $(playerctl --player=$current_player metadata -f "{{playerName}}")";;
    $OPT_GET_TIME) echo "󰎇 $(playerctl --player=$current_player metadata -f "{{duration(position)}}")";;
    *) echo "󰎇"
esac
