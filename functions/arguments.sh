#!/bin/sh

# arguments.sh - handle common arguments
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Arguments ()
{
	ARGUMENTS="$(getopt --longoptions breakpoints,conffile:,debug,force,help,quiet,usage,verbose,version --name=${PROGRAM} --options c:huv --shell sh -- "${@}")"

	if [ "${?}" != "0" ]
	then
		Echo_error "terminating" >&2
		exit 1
	fi

	eval set -- "${ARGUMENTS}"

	while true
	do
		case "${1}" in
			--breakpoints)
				_BREAKPOINTS="enabled"
				shift
				;;

			-c|--conffile)
				_CONFFILE="${2}"
				shift 2
				;;

			--debug)
				_DEBUG="enabled"
				shift
				;;

			--force)
				_FORCE="enabled"
				shift
				;;

			-h|--help)
				Help
				shift
				;;

			--quiet)
				_QUIET="enabled"
				shift
				;;

			-u|--usage)
				Usage
				shift
				;;

			--verbose)
				_VERBOSE="enabled"
				shift
				;;

			-v|--version)
				Version
				shift
				;;

			--)
				shift
				break
				;;

			*)
				Echo_error "internal error %s" "${0}"
				exit 1
				;;
		esac
	done
}
