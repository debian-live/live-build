#!/bin/sh

# packagelists.sh - expands package list includes
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Expand_packagelist ()
{
	# ${1} List name
	# ${2} Default path to search
	# ${3} Fallback path to search (optional)

	# Does list exist in default path?
	if [ -e "${2}/${1}" ];
	then
		Expand_packagelist_file "${2}/${1}" "${@}"
	else
		# If list exists in fallback, include it.
		if [ -n "${3}" ] && [ -e "${3}/${1}" ]
		then
			Expand_packagelist_file "${3}/${1}" "${@}"
		fi
	fi
}

Expand_packagelist_file ()
{
	local FILE="${1}"
	shift
	shift

	for INCLUDE in $(sed -ne 's|^#<include> \(.*\)|\1|gp' -e 's|^#include <\(.*\)>|\1|gp' "${FILE}")
	do
		Expand_packagelist "${INCLUDE}" "${@}"
	done
	sed -ne 's|^\([^#].*\)|\1\n|gp' "${FILE}"
}
