#include "./lib/gpp-bashful-utils/gpp-first.sh"
#ifndeff PAGER
#define PAGER
pager() #{{{1
{
    # <doc:pager> {{{
    #
    # Execute the preferred pager.
    #
    # </doc:pager> }}}

    $(first "$PAGER" "less")
}
#endif