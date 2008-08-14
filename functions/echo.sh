#!/bin/sh

# echo.sh - define output methods
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Echo ()
{
	STRING="${1}"
	shift

	printf "$(eval_gettext "${STRING}")" "${@}"; echo;
}

Echo_debug ()
{
	STRING="${1}"
	shift

	if [ "${LH_DEBUG}" = "enabled" ]
	then
		printf "D: $(eval_gettext "${STRING}")" "${@}"; echo;
	fi
}

Echo_error ()
{
	STRING="${1}"
	shift

	(printf "E: $(eval_gettext "${STRING}")" "${@}"; echo;) >&2
}

Echo_message ()
{
	STRING="${1}"
	shift

	if [ "${LH_QUIET}" != "enabled" ]
	then
		printf "P: $(eval_gettext "${STRING}")" "${@}"; echo;
	fi
}

Echo_verbose ()
{
	STRING="${1}"
	shift

	if [ "${LH_VERBOSE}" = "enabled" ]
	then
		printf "I: $(eval_gettext "${STRING}")" "${@}"; echo;
	fi
}

Echo_warning ()
{
	STRING="${1}"
	shift

	printf "W: $(eval_gettext "${STRING}")" "${@}"; echo;
}

Echo_breakage ()
{
	case "${LH_DISTRIBUTION}" in
		sid|unstable)
			Echo_message "If the following stage fails, the most likely cause of the problem is with your mirror configuration, a caching proxy or the sid distribution."
			;;
		*)
			Echo_message "If the following stage fails, the most likely cause of the problem is with your mirror configuration or a caching proxy."
			;;
	esac

	Echo_message "${@}"
}
