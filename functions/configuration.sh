#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Get_configuration ()
{
	_CONFIGURATION_FILE="${1}"
	_FIELD_NAME="${2}"

	if [ -e "${_CONFIGURATION_FILE}" ]
	then
		_FIELD_BODY="$(grep ^${_FIELD_NAME}: ${_CONFIGURATION_FILE} | awk '{ $1=""; print $0 }' | sed -e 's|^ ||')"
	fi

	echo ${_FIELD_BODY}
}

Set_configuration ()
{
	_CONFIGURATION_FILE="${1}"
	_FIELD_NAME="${2}"
	_FIELD_BODY="${3}"

	if grep -qs "^${_FIELD_NAME}:" "${_CONFIGURATION_FILE}"
	then
		# Update configuration
		sed -i -e "s|^${_FIELD_NAME}:.*$|${_FIELD_NAME}: ${_FIELD_BODY}|" "${_CONFIGURATION_FILE}"
	else
		# Append configuration
		echo "${_FIELD_NAME}: ${_FIELD_BODY}" >> "${_CONFIGURATION_FILE}"
	fi
}
