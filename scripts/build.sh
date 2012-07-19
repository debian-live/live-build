#!/bin/sh

if [ -e local/live-build ]
then
	LIVE_BUILD="${LIVE_BUILD:-${PWD}/local/live-build}"
	PATH="${PWD}/local/live-build/scripts/build:${PATH}"
	export LIVE_BUILD PATH
fi

# Source global functions
for FUNCTION in "${LIVE_BUILD}"/functions/*.sh /usr/share/live/build/functions/*.sh
do
	if [ -e "${FUNCTION}" ]
	then
		. "${FUNCTION}"
	fi
done

# Source local functions
if ls local/functions/* > /dev/null 2>&1
then
	for FUNCTION in local/functions/*
	do
		. "${FUNCTION}"
	done
fi
