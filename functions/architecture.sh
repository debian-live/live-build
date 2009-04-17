#!/bin/sh

# architecture.sh - handle architecture specific support
# Copyright (C) 2006-2009 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Check_architecture ()
{
	ARCHITECTURES="${@}"
	VALID="false"

	for ARCHITECTURE in ${ARCHITECTURES}
	do
		if [ "$(echo ${LH_ARCHITECTURE} | grep ${ARCHITECTURE})" ]
		then
			VALID="true"
			break
		fi
	done

	if [ "${VALID}" = "false" ]
	then
		Echo_warning "skipping %s, foreign architecture." "${0}"
		exit 0
	fi
}

Check_crossarchitecture ()
{
	if [ -x /usr/bin/dpkg ]
	then
		HOST="$(dpkg --print-architecture)"
	else
		HOST="$(uname -m)"
	fi

	case "${HOST}" in
		amd64|i386|lpia|x86_64)
			CROSS="amd64 i386 lpia"
			;;

		powerpc|ppc64)
			CROSS="powerpc ppc64"
			;;

		*)
			CROSS="${HOST}"
			;;
	esac

	Check_architecture "${CROSS}"
}

Check_multiarchitecture ()
{
	if [ "$(echo ${LH_ARCHITECTURE} | wc -w)" -gt "1" ]
	then
		# First, only support multiarch on iso
		if [ "${LH_BINARY_IMAGES}" = "iso" ]
		then
			# Assemble multi-arch
			case "${LH_CURRENT_ARCHITECTURE}" in
				amd64)
					DESTDIR="${DESTDIR}.amd"
					DESTDIR_LIVE="${DESTDIR_LIVE}.amd"
					DESTDIR_INSTALL="${DESTDIR_INSTALL}.amd"
					;;

				i386)
					DESTDIR="${DESTDIR}.386"
					DESTDIR_LIVE="${DESTDIR_LIVE}.386"
					DESTDIR_INSTALL="${DESTDIR_INSTALL}.386"
					;;

				lpia)
					DESTDIR="${DESTDIR}.lpi"
					DESTDIR_LIVE="${DESTDIR_LIVE}.lpi"
					DESTDIR_INSTALL="${DESTDIR_INSTALL}.lpi"
					;;

				powerpc)
					DESTDIR="${DESTDIR}.ppc"
					DESTDIR_LIVE="${DESTDIR_LIVE}.ppc"
					DESTDIR_INSTALL="${DESTDIR_INSTALL}.ppc"
					;;
			esac
		fi
	fi
}
