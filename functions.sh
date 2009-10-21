#!/bin/sh

LH_BASE="${LH_BASE:-/usr/share/live-helper}"

# Source global functions
for FUNCTION in "${LH_BASE}"/functions/*.sh
do
	. "${FUNCTION}"
done

# Source local functions
if [ -d scripts/functions ]
then
	for FUNCTION in scripts/functions/*.sh
	do
		. "${FUNCTION}"
	done
fi
