#!/bin/sh

# architecture.sh - handle architecture specific support
# Copyright (C) 2007 Otavio Salvador <otavio@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_architecture ()
{
	ARCHITECTURES="${@}"
	VALID="false"

	for ARCHITECTURE in ${ARCHITECTURES}
	do
		if [ "${ARCHITECTURE}" = "${LIVE_ARCHITECTURE}" ]
		then
			VALID="true"
			break
		fi
	done

	if [ "${VALID}" = "false" ]
	then
		Echo_warning "skipping ${0}, foreign architecture."
		exit 0
	fi
}
