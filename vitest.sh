#!/bin/bash
NVIM_CMD=$(type -p nvim 2>/dev/null)
VIM_CMD=$(type -p vim 2>/dev/null)
VI_CMD=$(type -p vi 2>/dev/null)

if [ ! -z $NVIM_CMD ]; then
    echo "found nvim"
    alias vi='nvim'
elif [ ! -z $VIM_CMD ]; then
    echo "found vim"
    alias vi='vim'
else
    echo "Can't find vi! What the hell, man?"
fi

