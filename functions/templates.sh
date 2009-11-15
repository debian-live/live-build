#!/bin/sh

# templates.sh - handle templates files
# Copyright (C) 2006-2009 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Check_templates ()
{
	PACKAGE="${1}"

	if [ -d "config/templates/${PACKAGE}" ]
	then
		TEMPLATES="config/templates/${PACKAGE}"
	elif [ -d "${LH_TEMPLATES}/${PACKAGE}" ]
	then
		TEMPLATES="${LH_TEMPLATES}/${PACKAGE}"
	else
		Echo_error "%s templates not accessible in %s nor config/templates" "${PACKAGE}" "${LH_TEMPLATES}"
		exit 1
	fi
}
