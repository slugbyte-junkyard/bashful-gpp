#!/bin/bash

# Filename:      bashful.sh
# Description:   An interface to bashful for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Wed 2010-02-10 10:24:11 (-0500)

(( ${BASH_LINENO:-0} > 0 )) && exit

source bashful-autodoc
source bashful-files
source bashful-input
source bashful-messages
source bashful-modes
source bashful-profile
source bashful-terminfo
source bashful-utils

"$@"