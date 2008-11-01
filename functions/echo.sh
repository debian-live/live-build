#!/bin/sh

# echo.sh - define output methods
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Echo ()
{
	STRING="${1}"
	shift

	if [ "${_L10N}" = "false" ]
	then
		printf "${STRING}\n"
	else
		printf "$(eval_gettext "${STRING}")" "${@}"; echo;
	fi
}

Echo_debug ()
{
	STRING="${1}"
	shift

	if [ "${_DEBUG}" = "enabled" ]
	then
		if [ "${_L10N}" = "false" ]
		then
			printf "D: ${STRING}\n"
		else
			printf "D: $(eval_gettext "${STRING}")" "${@}"; echo;
		fi
	fi
}

Echo_error ()
{
	STRING="${1}"
	shift

	if [ "${_L10N}" = "false" ]
	then
		printf "E: ${STRING}\n" >&2
	else
		(printf "E: $(eval_gettext "${STRING}")" "${@}"; echo;) >&2
	fi
}

Echo_message ()
{
	STRING="${1}"
	shift

	if [ "${LH_QUIET}" != "enabled" ]
	then
		if [ "${_L10N}" = "false" ]
		then
			printf "P: ${STRING}\n"
		else
			printf "P: $(eval_gettext "${STRING}")" "${@}"; echo;
		fi
	fi
}

Echo_verbose ()
{
	STRING="${1}"
	shift

	if [ "${LH_VERBOSE}" = "enabled" ]
	then
		if [ "${_L10N}" = "false" ]
		then
			printf "I: ${STRING}\n"
		else
			printf "I: $(eval_gettext "${STRING}")" "${@}"; echo;
		fi
	fi
}

Echo_warning ()
{
	STRING="${1}"
	shift

	if [ "${_L10N}" = "false" ]
	then
		printf "W: ${STRING}\n"
	else
		printf "W: $(eval_gettext "${STRING}")" "${@}"; echo;
	fi
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

Echo_file ()
{
	while read LINE
	do
		echo "${1}: ${LINE}"
	done < "${1}"
}
