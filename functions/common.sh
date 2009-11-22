#!/bin/sh

# common.sh - common things for all live-helpers
# Copyright (C) 2006-2009 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

PROGRAM="$(basename ${0})"
PACKAGE="live-helper"
VERSION="2.0~a1-1"
CONFIG_VERSION="$(echo ${VERSION} | awk -F- '{ print $1 }')"

PATH="${PWD}/scripts:${PATH}"
