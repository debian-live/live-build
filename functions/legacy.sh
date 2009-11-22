#!/bin/sh

# legacy.sh - handle live-helper 2.x warnigns
# Copyright (C) 2006-2009 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

# Obsoleting 'lh_foo_bar' calls in favour for 'lh foo_bar'

BASENAME="$(basename ${0})"

if [ -z "${LH}" ] && [ "$(echo ${BASENAME} | awk '{ print $1 }')" != "lh" ]
then
	Echo_warning "live-helper 2.0 will deprecate all dashed forms of commands."
	Echo_warning "Please use \'$(echo ${BASENAME} | sed -e 's|lh_|lh |')\' instead of \'${BASENAME}\'."
fi
