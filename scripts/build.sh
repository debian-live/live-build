#!/bin/sh

if [ -e local/live-build ]
then
	LIVE_BUILD="${LIVE_BUILD:-${PWD}/local/live-build}"
	export LIVE_BUILD
fi

for _DIRECTORY in "${LIVE_BUILD}/functions" /usr/share/live/build/functions
do
	if [ -e "${_DIRECTORY}" ]
	then
		for _FILE in "${_DIRECTORY}"/*.sh
		do
			if [ -e "${_FILE}" ]
			then
				. "${_FILE}"
			fi
		done

		break
	fi
done
