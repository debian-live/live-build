#!/bin/sh

LH_BASE="${LH_BASE:-/usr/share/live-helper}"

# Source global functions
for FUNCTION in "${LH_BASE}"/functions/*.sh
do
	. "${FUNCTION}"
done

# Source local functions
if ls scripts/functions/*.sh > /dev/null 2>&1
then
	for FUNCTION in scripts/functions/*.sh
	do
		. "${FUNCTION}"
	done
fi
