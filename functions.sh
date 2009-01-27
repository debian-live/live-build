#!/bin/sh

LH_BASE="${LH_BASE:-/usr/share/live-helper}"

for FUNCTION in "${LH_BASE}"/functions/*.sh
do
	. "${FUNCTION}"
done
