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
		_LH_NESTED=0
		_LH_ENABLED=1

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

		while read _LH_LINE
		do
			case "${_LH_LINE}" in
				\#if\ *)
					if [ ${_LH_NESTED} -eq 1 ]
					then
						echo "E: Nesting conditionals is not supported" >&2
						exit 1
					fi

					_LH_NESTED=1
					_LH_VAR="$(echo "${_LH_LINE}" | cut -d' ' -f2)"
					_LH_VAL="$(echo "${_LH_LINE}" | cut -d' ' -f3-)"
					_LH_MATCH="$(echo ${_LH_VAL} |grep "\(^\| \)$(eval "echo \$LH_${_LH_VAR}")\($\| \)")" || true

					if [ -n "${_LH_VAR}" ] &&  [ -z "${_LH_MATCH}" ]
					then
						_LH_ENABLED=0
					fi
					;;

				\#endif*)
					_LH_NESTED=0
					_LH_ENABLED=1
					;;

				\#*)
					if [ ${_LH_ENABLED} -ne 1 ]
					then
						continue
					fi

					# Find includes
					_LH_INCLUDES="$(echo "${_LH_LINE}" | sed -n \
						-e 's|^#<include> \([^ ]*\)|\1|gp' \
						-e 's|^#include <\([^ ]*\)>|\1|gp')"

					# Add to queue
					_LH_EXPAND_QUEUE="$(echo ${_LH_EXPAND_QUEUE} ${_LH_INCLUDES} |
						sed -e 's|[ ]*$||' -e 's|^[ ]*||')"
					;;

				*)
					if [ ${_LH_ENABLED} -eq 1 ]
					then
						echo "${_LH_LINE}"
					fi
					;;

			esac
		done < "${_LH_LIST_LOCATION}"
	done
}
