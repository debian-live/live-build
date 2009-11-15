#!/bin/sh

# losetup - wrapper around losetup
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Losetup ()
{
	DEVICE="${1}"
	FILE="${2}"
	PARTITION="${3:=1}"

	${LH_ROOT_COMMAND} ${LH_LOSETUP} "${DEVICE}" "${FILE}"
	FDISK_OUT="$(${LH_FDISK} -l -u ${DEVICE} 2>&1)"
	${LH_ROOT_COMMAND} ${LH_LOSETUP} -d "${DEVICE}"

	LOOPDEVICE="$(echo ${DEVICE}p${PARTITION})"

	if [ "${PARTITION}" = "0" ]
	then
		Echo_message "Mounting ${DEVICE} with offset 0"

		${LH_ROOT_COMMAND} ${LH_LOSETUP} "${DEVICE}" "${FILE}"
	else
		CYLINDERS="$(echo "$FDISK_OUT" | sed -ne "s|^$LOOPDEVICE[ *]*\([0-9]*\).*|\1|p")"
		OFFSET="$(expr ${CYLINDERS} '*' 512)"

		Echo_message "Mounting ${DEVICE} with offset ${OFFSET}"

		${LH_ROOT_COMMAND} ${LH_LOSETUP} -o "${OFFSET}" "${DEVICE}" "${FILE}"
	fi
}
