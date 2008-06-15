#!/bin/sh

# echo.sh - define output methods
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Echo_debug ()
{
	STRING="${1}"

	if [ "${LH_DEBUG}" = "enabled" ]
	then
		echo "D: ${STRING}"
	fi
}

Echo_error ()
{
	STRING="${1}"

	echo "E: ${STRING}" >&2
}

Echo_message ()
{
	STRING="${1}"

	if [ "${LH_QUIET}" != "enabled" ]
	then
		echo "P: ${STRING}"
	fi
}

Echo_verbose ()
{
	STRING="${1}"

	if [ "${LH_VERBOSE}" = "enabled" ]
	then
		echo "I: ${STRING}"
	fi
}

Echo_warning ()
{
	STRING="${1}"

	echo "W: ${STRING}"
}

Echo_breakage ()
{
	Echo_message "If the following stage fails, the most likely cause of the problem is with"

	case "${LH_DISTRIBUTION}" in
		sid|unstable)
			Echo_message "your mirror configuration, a caching proxy or the sid distribution."
			;;
		*)
			Echo_message "your mirror configuration or a caching proxy."
			;;
	esac

	Echo_message "${@}"
}
