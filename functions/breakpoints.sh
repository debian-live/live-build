#!/bin/sh

# breakpoints.sh - run with breakpoints
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Breakpoint ()
{
	NAME="${1}"

	if [ "${LH_BREAKPOINTS}" = "enabled" ]
	then
		Echo_message "Waiting at %s" "${NAME}"
		read WAIT
	fi
}
