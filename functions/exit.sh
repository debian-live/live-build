#!/bin/sh

# exit.sh - cleanup
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Exit ()
{
	if [ "${LH_DEBUG}" = "enabled" ]
	then
		set | grep -e ^LH -e ^LIVE
	fi

	# FIXME: Add /proc et al cleanup on failure
}
