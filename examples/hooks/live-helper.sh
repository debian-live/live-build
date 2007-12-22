#!/bin/sh

# This is a hook for live-helper(7) to install live-helper and its config into
# the binary image.
# To enable it, copy this hook into your config/binary_local-hooks directory.

DIRECTORY="binary/tools/live"

mkdir -p "${DIRECTORY}"

cp -a config "${DIRECTORY}"

if [ -e live-helper ]
then
	cp -a live-helper "${DIRECTORY}"
else
	mkdir -p "${DIRECTORY}"/live-helper/bin
	cp -a /usr/bin/lh* "${DIRECTORY}"/live-helper/bin

	cp -a /usr/share/live-helper "${DIRECTORY}"/live-helper/share

	cp -a /usr/share/doc/live-helper "${DIRECTORY}"/live-helper/doc
fi
