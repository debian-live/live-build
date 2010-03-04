#!/bin/sh

# conffile.sh - handle configuration files
# Copyright (C) 2006-2010 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Get_conffiles ()
{
	if [ -n "${LH_CONFIG}" ]
	then
		FILES="${LH_CONFIG}"
	else
		for FILE in ${@}
		do
			FILES="${FILES} ${FILE} ${FILE}.${LH_ARCHITECTURE} ${FILE}.${DISTRIBUTION}"
			FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||')"
			FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||').${ARCHITECTURE}"
			FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||').${DISTRIBUTION}"
		done
	fi

	echo ${FILES}
}

Read_conffiles ()
{
	for CONFFILE in Get_conffiles "${@}"
	do
		if [ -f "${CONFFILE}" ]
		then
			if [ -r "${CONFFILE}" ]
			then
				Echo_debug "Reading configuration file %s" "${CONFFILE}"
				. "${CONFFILE}"
			else
				Echo_warning "Failed to read configuration file %s" "${CONFFILE}"
			fi
		fi
	done
}

Print_conffiles ()
{
	for CONFFILE in Get_conffiles "${@}"
	do
		if [ -f "${CONFFILE}" ]
		then
			Echo_file "${CONFFILE}"
		fi
	done
}
