#!/bin/sh

# echo.sh - define output methods
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Echo_debug ()
{
	if [ "${LH_DEBUG}" = "enabled" ]
	then
		echo "D: ${@}"
	fi
}

Echo_error ()
{
	echo "E: ${@}"
}

Echo_message ()
{
	if [ "${LH_QUIET}" != "enabled" ]
	then
		echo "P: ${@}"
	fi
}

Echo_verbose ()
{
	if [ "${LH_VERBOSE}" = "enabled" ]
	then
		echo "I: ${@}"
	fi
}

Echo_warning ()
{
	echo "W: ${@}"
}
