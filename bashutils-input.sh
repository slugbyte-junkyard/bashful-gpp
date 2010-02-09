#!/bin/bash

# Filename:      bashutils-input.sh
# Description:   A set of functions for interacting with the user.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-02-08 23:34:38 (-0500)

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_INPUT_LOADED ]] && return

source bashutils-messages
source bashutils-modes
source bashutils-utils

input() #{{{1
{
    # autodoc-begin input {{{
    #
    # Prompts the user to input text.
    #
    # Usage: input [-cs] [-p PROMPT] [-d DEFAULT]
    #
    # Usage examples:
    #
    # If user presses enter with no response, foo is taken as the input:
    #     input -p "Enter value" -d foo
    #
    # User will only be prompted if interactive mode is enabled:
    #     input -c -p "Enter value"
    #
    # Input will be hidden:
    #     input -s -p "Enter password"
    #
    # autodoc-end input }}}

    local p="Enter value"
    local d c s reply

    unset OPTIND
    while getopts ":p:d:cs" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
            s) s=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $s; then
        if gui; then
            secret="--hide-text"
        else
            secret="-s"
        fi
    fi

    if truth $c && ! interactive; then
        echo "$d"
        return
    fi

    if gui; then
        reply=$(z "$p" --entry $s --entry-text="$d") || return 1
    else
        read $s -ep "${p}${d:+ [$d]}: " reply || return 1
        [[ $s ]] && echo >&2
    fi

    echo "${reply:-$d}"
}

input_lines() #{{{1
{
    # autodoc-begin input_lines {{{
    #
    # Prompts the user to input text lists.
    #
    # Usage: input_lines [-c] [-p PROMPT]
    #
    # autodoc-end input_lines }}}

    local p="Enter values"
    local c reply

    unset OPTIND
    while getopts ":p:cs" option; do
        case $option in
            p) p=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return
    fi

    prompt+=" (one per line)"

    if gui; then
        z "$p" --text-info --editable
    else
        echo "$p:" >&2
        cat  # Accept input until EOF (ctrl-d)
    fi
}

question() #{{{1
{
    # autodoc-begin question {{{
    #
    # Prompts the user with a yes/no question.
    #
    # The default value can be anything that evaluates to true/false.
    # See documentation for the "truth" command for more info.
    #
    # Usage: question [-c] [-p PROMPT] [-d DEFAULT]
    #
    # Usage examples:
    #
    # If user presses enter with no response, answer will be "yes":
    #     question -p "Continue?" -d1
    #
    # User will only be prompted if interactive mode is enabled:
    #     question -c -p "Continue?"
    #
    # autodoc-end question }}}

    prompt="Are you sure you want to proceed?"
    local default check reply choice

    unset OPTIND
    while getopts ":p:d:c" option; do
        case $option in
            p) prompt=$OPTARG ;;
            d) default=$OPTARG ;;
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! interactive; then
        return 0
    fi

    if truth "$default"; then
        default=y
    else
        default=n
    fi

    if ! gui; then
        prompt="$prompt [$(sed "s/\($default\)/\u\1/i" <<<"yn")]: "
    fi

    until [[ $choice ]]; do
        if gui; then
            if z "$prompt" --question; then
                choice=y
            else
                choice=n
            fi
        else
            read -e -n1 -p "$prompt" choice
        fi
        choice=$(first "$choice" "$default" | trim | lower)
        case $choice in
            y) choice=0 ;;
            n) choice=1 ;;
            *)
                error "Invalid choice."
                unset choice
                ;;
        esac
    done

    return $choice
}

choice() #{{{1
{
    # autodoc-begin choice {{{
    #
    # Prompts the user to choose from a set of choices.
    # If there is only one choice, it will be returned immediately.
    #
    # Usage: choice [-c] [-p PROMPT] [CHOICE...]
    #
    # Usage examples:
    #     choice -p "Choose your favorite color" red green blue
    #
    # autodoc-end choice }}}

    local prompt="Select from these choices"
    local prompt check

    unset OPTIND
    while getopts ":p:c" option; do
        case $option in
            p) prompt=$OPTARG ;;
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! interactive; then
        return
    fi

    if (( $# <= 1 )); then
        echo "$1"
        exit
    fi

    if gui; then
        printf "%s\n" "$@" |
        z "$prompt" --list --column="Choices" || return 1
    else
        echo "$prompt:" >&2
        select choice in "$@"; do
            if [[ $choice ]]; then
                echo "$choice"
                break
            fi
        done
    fi
}

#}}}1

BASHUTILS_INPUT_LOADED=1