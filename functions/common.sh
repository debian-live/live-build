#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2012 Daniel Baumann <daniel@debian.org>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


PROGRAM="live-build"
VERSION="$(if [ -e ${LIVE_BUILD}/VERSION ]; then cat ${LIVE_BUILD}/VERSION; else cat /usr/share/live/build/VERSION; fi)"
CONFIG_VERSION="$(echo ${VERSION} | awk -F- '{ print $1 }')"

PATH="${PWD}/local/bin:${PATH}"
