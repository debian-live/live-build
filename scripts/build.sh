#!/bin/sh

if [ -e local/live-build ]
then
	LIVE_BUILD="${LIVE_BUILD:-${PWD}/local/live-build}"
	export LIVE_BUILD
fi

# Source global functions
for FUNCTION in "${LIVE_BUILD}"/functions/*.sh /usr/share/live/build/functions/*.sh
do
	if [ -e "${FUNCTION}" ]
	then
		. "${FUNCTION}"
	fi
done
