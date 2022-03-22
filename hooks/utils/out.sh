#!/usr/bin/env bash

#
# A simple bash function to output messages
#
# Usage:
#   out "Hello world!"
#   out warn "A warning message"
#   out error "An error message"
#

function out () {
    local RST="\033[0m"
    local YELLOW="\033[0;33m"
    local MAGENTA="\033[0;35m"
    local CYAN="\033[0;36m"
    local LIGHT_YELLOW="\033[0;93m"
    local LIGHT_MAGENTA="\033[0;95m"
    local LIGHT_CYAN="\033[0;96m"

    local msg=$1
    local color_1=$CYAN
    local color_2=$LIGHT_CYAN

    if [[ $1 == "warn" ]]; then
        msg=$2
        color_1=$YELLOW
        color_2=$LIGHT_YELLOW
    elif [[ $1 == "error" ]]; then
        msg=$2
        color_1=$MAGENTA
        color_2=$LIGHT_MAGENTA
    fi

    echo -e "${color_1}❯${color_2} $msg${RST}"
}
