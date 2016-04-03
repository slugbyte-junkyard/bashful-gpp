#include "1459670344-tmp/gpp-profile_file.sh"
#include "1459670344-tmp/gpp-error.sh"
#ifndeff PROFILE_VERIFY
#define PROFILE_VERIFY
profile_verify() #{{{1
{
    # <doc:profile_verify> {{{
    #
    # Make sure the profile file exists before continuing.
    #
    # </doc:profile_verify> }}}

    profile_file || return 1

    if [[ ! -f $PROFILE_FILE ]]; then
        error "Profile '$PROFILE' does not exist or not a regular file."
        return 1
    fi
}
#endif