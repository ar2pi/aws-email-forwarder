#!/usr/bin/env bash

#
# A simple bash script to execute all adjacent scripts
#
# Usage:
#   source /path/to/all.sh
#   OR
#   . /path/to/all.sh
#
# Options:
#   -v|--verbose: verbose output
#

function main () {
    local CURRENT_SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
    local CURRENT_SCRIPT_FILE=$(basename ${BASH_SOURCE[0]})
    local modules=$(ls -1 $CURRENT_SCRIPT_DIR | grep -v $CURRENT_SCRIPT_FILE)
    local is_verbose=$([[ ! -z ${1+_} && ($1 = "-v" || $1 = "--verbose") ]] && echo "1" || echo "0")

    for module in $modules; do
        if [[ -f $CURRENT_SCRIPT_DIR/$module ]]; then
            . $CURRENT_SCRIPT_DIR/$module
            if [[ $is_verbose = 1 ]]; then
                echo "Loaded $CURRENT_SCRIPT_DIR/$module"
            fi
        fi
    done
}

main "$@"
