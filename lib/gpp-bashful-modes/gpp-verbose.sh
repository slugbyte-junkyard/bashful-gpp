#include "./lib/gpp-bashful-modes/gpp-truth_value.sh"
#include "./lib/gpp-bashful-modes/gpp-truth.sh"
#ifndeff VERBOSE
#define VERBOSE
verbose() #{{{1
{
    # <doc:verbose> {{{
    #
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
    #
    # Usage: verbose [VALUE]
    #
    # </doc:verbose> }}}

    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi

    export VERBOSE=$(truth_value $1)
}
#endif