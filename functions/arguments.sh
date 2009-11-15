#!/bin/sh

# arguments.sh - handle common arguments
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

PROGRAM="`basename ${0}`"

Arguments ()
{
	ARGUMENTS="`getopt --longoptions force,help,usage,version --name=${PROGRAM} --options huv --shell sh -- "${@}"`"

	if [ "${?}" != "0" ]
	then
		echo "terminating" >&2
		exit 1
	fi

	eval set -- "${ARGUMENTS}"

	while true
	do
		case "${1}" in
			--conffile)
				CONFFILE="FIXME"; shift
				;;

			--debug)
				DEBUG="FIXME"; shift
				;;

			--force)
				FORCE="true"; shift
				;;

			-h|--help)
				Help; shift
				;;

			--logfile)
				LOGFILE="FIXME"; shift
				;;

			--quiet)
				QUIET="FIXME"; shift
				;;

			-u|--usage)
				Usage; shift
				;;

			--verbose)
				VERBOSE="FIXME"; shift
				;;

			-v|--version)
				Version; shift
				;;

			--)
				shift; break
				;;

			*)
				echo "internal error"
				exit 1
				;;
		esac
	done
}
