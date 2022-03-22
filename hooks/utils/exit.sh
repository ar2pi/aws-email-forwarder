#!/usr/bin/env bash

function exit_if_not_main_branch () {
    if [[ $current_branch != $main_branch ]]; then
        # don't execute on anything other than main branch
        exit 0
    fi
}

function exit_if_ci () {
    if [[ $(git log -1 --format=%s | grep -E "^ci: ") ]]; then
        # don't execute if last commit starts with 'ci: '
        exit 0
    fi
}
