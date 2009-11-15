#!/bin/sh

# conffile.sh - handle configuration files
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Read_conffile ()
{
	FILES="${1} ${1}.${LH_ARCHITECTURE} ${1}.${DISTRIBUTION}"
	FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||')"
	FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||').${ARCHITECTURE}"
	FILES="${FILES} config/$(echo ${PROGRAM} | sed -e 's|^lh_||').${DISTRIBUTION}"

	for FILE in ${FILES}
	do
		if [ -f "${FILE}" ]
		then
			if [ -r "${FILE}" ]
			then
				Echo_debug "Reading configuration file ${FILE}"
				. "${FILE}"
			else
				Echo_warning "Failed to read configuration file ${FILE}"
			fi
		fi
	done
}
