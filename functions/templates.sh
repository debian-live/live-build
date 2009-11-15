#!/bin/sh

# templates.sh - handle templates files
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Check_templates ()
{
	ITEM="${1}"

	# Check user defined templates directory
	if [ ! -d "${LIVE_TEMPLATES}" ]
	then
		if [ -d config/templates ]
		then
			LIVE_TEMPLATES=config/templates
		else
			Echo_error "templates not accessible in ${LIVE_TEMPLATES} nor config/templates"
			exit 1
		fi
	fi

	if [ -d "${LIVE_TEMPLATES}/${ITEM}" ]
	then
		TEMPLATES="${LIVE_TEMPLATES}/${ITEM}"
	else
		Echo_error "${ITEM} templates not accessible in ${LIVE_TEMPLATES}"
		exit 1
	fi
}
