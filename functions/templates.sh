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
	PACKAGE="${1}"

	# Check user defined templates directory
	if [ ! -e "${LH_TEMPLATES}" ]
	then
		if [ -d config/templates ]
		then
			LH_TEMPLATES=config/templates
		else
			Echo_error "templates not accessible in ${LH_TEMPLATES} nor config/templates"
			exit 1
		fi
	fi

	if [ -d "${LH_TEMPLATES}/${PACKAGE}" ]
	then
		TEMPLATES="${LH_TEMPLATES}/${PACKAGE}"
	else
		Echo_error "${PACKAGE} templates not accessible in ${LH_TEMPLATES}"
		exit 1
	fi
}
