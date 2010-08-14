#!/bin/sh

LH_BASE="${LH_BASE:-/usr/share/live/build}"

# Source global functions
for FUNCTION in "${LH_BASE}"/functions/*.sh
do
	. "${FUNCTION}"
done

# Source local functions
if ls auto/functions/* > /dev/null 2>&1
then
	for FUNCTION in auto/functions/*
	do
		. "${FUNCTION}"
	done
fi
