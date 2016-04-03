#include "1459670344-tmp/gpp-truth_value.sh"
#include "1459670344-tmp/gpp-truth.sh"
#ifndeff INTERACTIVE
#define INTERACTIVE
interactive() #{{{1
{
    # <doc:interactive> {{{
    #
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
    #
    # Usage: interactive [VALUE]
    #
    # </doc:interactive> }}}

    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi

    export INTERACTIVE=$(truth_value $1)
}
#endif