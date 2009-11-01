#!/bin/bash

source bashutils-utils

gui() #{{{1
{
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.

    if (( $# == 0 )); then
        if [[ $DISPLAY ]]; then
            truth $GUI && return 0
        fi
        return 1
    fi
    export GUI=$(truth_value $1)
}

interactive() #{{{1
{
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.

    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi
    export INTERACTIVE=$(truth_value $1)
}

verbose() #{{{1
{
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.

    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi
    export VERBOSE=$(truth_value $1)
}

verbose_execute() #{{{1
{
    # Will execute the given command and only display the output if verbose
    # mode is enabled.

    if verbose; then
        "$@"
    else
        "$@" &>/dev/null
    fi
}