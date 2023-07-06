#!/bin/bash

CURRENT_PLAYER_FILE=~/.config/scripts/playerctrl/current-player.txt

LABEL_VOID="None"


current_player=$([[ -f $CURRENT_PLAYER_FILE ]] && head -n 1 $CURRENT_PLAYER_FILE)

if [[ -z $current_player ]]; then
    current_player=$LABEL_VOID
fi

status_player=$(playerctl --player=$current_player status 2>&1)

if [[ $status_player == "No players found" ]]; then
    old_player=$current_player
    current_player=$LABEL_VOID
    
    all_players=($(playerctl -l 2> /dev/null))
    
    if [[ -z $all_players ]]; then
        [[ $old_player != $LABEL_VOID ]] && echo -n > $CURRENT_PLAYER_FILE
        
        exit 0
    fi
    
    for player in ${all_players[@]}; do
        if [[ $(playerctl --player=$player status) == "Playing" ]]; then
            current_player=$player
            
            break
        fi
    done
    
    if [[ $current_player == $LABEL_VOID ]]; then
        current_player=${all_players[0]}
    fi
    
    echo -n $current_player > $CURRENT_PLAYER_FILE
    
elif [[ $1 == "next" ]]; then
    all_players=($(playerctl -l 2> /dev/null))
    len_all_players=${#all_players[@]}
    
    for (( i=0 ; i < len_all_players ; ++i )); do
        if [[ $current_player == ${all_players[$i]} ]]; then
            idx=$(( ($i + 1) % $len_all_players ))
            
            current_player=${all_players[$idx]}
            
            break
        fi
    done
    
    echo -n $current_player  > $CURRENT_PLAYER_FILE
fi

echo $current_player
