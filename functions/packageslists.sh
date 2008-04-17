#!/bin/sh

# packagelists.sh - expands package list includes
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Expand_packagelist ()
{
	_LH_EXPAND_QUEUE="$(basename "${1}")"

	shift

	while [ -n "${_LH_EXPAND_QUEUE}" ]
	do
		_LH_LIST_NAME="$(echo ${_LH_EXPAND_QUEUE} | cut -d" " -f1)"
		_LH_EXPAND_QUEUE="$(echo ${_LH_EXPAND_QUEUE} | cut -s -d" " -f2-)"
		_LH_LIST_LOCATION=""

		for _LH_SEARCH_PATH in ${@} "${LH_BASE:-/usr/share/live-helper}/lists"
		do
			if [ -e "${_LH_SEARCH_PATH}/${_LH_LIST_NAME}" ]
			then
				_LH_LIST_LOCATION="${_LH_SEARCH_PATH}/${_LH_LIST_NAME}"
			fi
		done

		if [ -z "${_LH_LIST_LOCATION}" ]
		then
			echo "W: Unknown package list '${_LH_LIST_NAME}'" >&2
			continue
		fi

		# Output packages
		grep -v "^#" ${_LH_LIST_LOCATION} | grep .

		# Find includes
		_LH_INCLUDES="$(sed -n \
			-e 's|^#<include> \([^ ]*\)|\1|gp' \
			-e 's|^#include <\([^ ]*\)>|\1|gp' \
			"${_LH_LIST_LOCATION}")"

		# Add to queue
		_LH_EXPAND_QUEUE="$(echo ${_LH_EXPAND_QUEUE} ${_LH_INCLUDES} | \
			sed -e 's|[ ]*$||' -e 's|^[ ]*||')"
	done
}
