#!/bin/sh

# templates.sh - handle templates files
# Copyright (C) 2007 Otavio Salvador <otavio@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_templates ()
{
	PROGRAM="${1}"

	# Check local templates
	if [ -d config/templates/"${PROGRAM}" ]
	then
		LIVE_TEMPLATES="config/templates"
	fi

	# Checking user templates
	if [ ! -d "${LIVE_TEMPLATES}" ]
	then
		Echo_error "user specified templates not accessible in ${LIVE_TEMPLATES}"
		exit 1
	elif [ ! -d "${LIVE_TEMPLATES}/${PROGRAM}" ]
	then
		Echo_error "${PROGRAM} templates not accessible in ${LIVE_TEMPLATES}"
		exit 1
	fi
}
