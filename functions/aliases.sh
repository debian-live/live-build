#!/bin/sh

# aliases.sh - internal shell aliases
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Truncate ()
{
	for FILE in ${@}
	do
		: > ${FILE}
	done
}
