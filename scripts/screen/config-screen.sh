#!/bin/bash


RE_PATTERN_NUMBER=[0-9]

INTERNAL=eDP-1
INTERNAL_WIDTH=1366
INTERNAL_HEIGHT=768

EXTERNAL=HDMI-1


if [[ $1 == "--help" ]]; then
    echo "- only => M_Int"
    echo

    echo "- top => M_Ext"
    echo "|-->     M_Int"
    echo

    echo "- right => M_Int|M_Ext"
    echo

    echo "- bottom => M_Int"
    echo "|-->        M_Ext"
    echo

    echo "- left,[default] => M_Ext|M_Int"
    echo

    exit 0
fi


external_info=$(xrandr | grep -Pzo "$EXTERNAL (.*(\n))*")

if [[ -z external_info ]]; then
    xrandr --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos 0x0
    
    exit 0
fi


offset-x(){
    local tmp=$(( ($INTERNAL_WIDTH - ${prefer_mode[0]}) / 2 ))
    offset_left=${tmp/#-}
}

offset-y(){
    local tmp=$(( $INTERNAL_HEIGHT - ${prefer_mode[1]} ))
    offset_top=${tmp/#-}
}

monitor_only_internal(){
    xrandr --output $EXTERNAL --mode 0x0 --pos 0x0 \
    --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos 0x0
}

monitor_external_left(){
    xrandr --output $EXTERNAL --mode $(echo $extern_w)x$(echo $extern_h) --pos 0x0 \
    --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos $(echo $extern_w)x$(echo $offset_top)
}

monitor_external_right(){
    xrandr --output $EXTERNAL --mode $(echo $extern_w)x$(echo $extern_h) --pos $(echo $INTERNAL_WIDTH)x0 \
    --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos 0x$(echo $offset_top)
}

monitor_external_top(){
    xrandr --output $EXTERNAL --mode $(echo $extern_w)x$(echo $extern_h) --pos 0x0 \
    --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos $(echo $offset_left)x$(echo $extern_h)
}

monitor_external_bottom(){
    xrandr --output $EXTERNAL --mode $(echo $extern_w)x$(echo $extern_h) --pos 0x$(echo $INTERNAL_HEIGHT) \
    --output $INTERNAL --mode $(echo $INTERNAL_WIDTH)x$(echo $INTERNAL_HEIGHT) --pos $(echo $offset_left)x0
}


if [[ $(echo $external_info | grep "disconnected") ]]; then
    monitor_only_internal
    
    exit 0
fi

prefer_mode=($(echo "$external_info" | grep -Pzo "[ ]?.*?\+(\n)" | grep -Pzo "$RE_PATTERN_NUMBER+x$RE_PATTERN_NUMBER+" | tr "x" " "))

offset-x
offset-y

extern_w=${prefer_mode[0]}
extern_h=${prefer_mode[1]}

case $1 in
    only) monitor_only_internal;;
    top) monitor_external_top;;
    bottom) monitor_external_bottom;;
    right) monitor_external_right;;
    *) monitor_external_left;;
esac
