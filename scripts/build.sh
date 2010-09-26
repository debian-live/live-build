#!/bin/sh

LB_BASE="${LB_BASE:-/usr/share/live/build}"

# Source global functions
for FUNCTION in "${LB_BASE}"/functions/*.sh
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
