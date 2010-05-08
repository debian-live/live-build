#!/bin/sh

set -e

. ../functions/common.sh

echo "Updating version headers..."

for MANPAGE in en/*
do
	SECTION="$(basename ${MANPAGE} | awk -F. '{ print $2 }')"

	sed -i -e "s|^.TH.*$|.TH LIVE\\\-HELPER ${SECTION} $(date +%Y\\\\-%m\\\\-%d) ${CONFIG_VERSION} \"Debian Live Project\"|" ${MANPAGE}
done
