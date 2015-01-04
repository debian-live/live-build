#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2015 Daniel Baumann <mail@daniel-baumann.ch>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


Man ()
{
	if [ -x "$(which man 2>/dev/null)" ]
	then
		man $(basename ${0})
		exit 0
	fi
}
