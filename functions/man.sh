#!/bin/sh

# man.sh - print man information
# Copyright (C) 2006-2010 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Man ()
{
	if [ -x "$(which man 2>/dev/null)" ]
	then
		man lh_$(basename ${0})
		exit 0
	fi
}
