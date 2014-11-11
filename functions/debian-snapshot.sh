#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2012 Daniel Baumann <daniel@debian.org>
##
## live-build comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.

Short_date ()
{
	SHORT_DATE="${1}:-${LB_SNAPSHOT}}"
	# returns the date as YYYYMMDD
	echo "${SHORT_DATE}" | cut -c 1-8
}

Last_archive_entry ()
{
	# returns the last date link
	LAST_ENTRY="$(cat /tmp/index.html | grep "$(date +%Y%m)" | sed 's|.*<a href="\([^"]*\)".*$|\1|' | tail -n 1 )"
	echo "$( echo ${LAST_ENTRY} | sed 's|./||' | sed 's|/||' )"
}

First_archive_entry ()
{
	# returns the 1st date link (1st line is daily-images in daily installer html)
	FIRST_ENTRY="$(cat /tmp/index.html | grep DIR | sed 's|.*<a href="\([^"]*\)".*$|\1|' | head -n 2 | tail -n 1 )"
	echo "$( echo ${FIRST_ENTRY} | sed 's|./||' | sed 's|/||' )"
}

Previous_date ()
{
	INITIAL_DATE="${1}"

	# convert date to seconds
	UNIX_TIME=$(date -d "$INITIAL_DATE" +%s)
	# one day is 86400 secs
	#ONE_DAY=$(( 24 * 3600 ))
	ONE_DAY=86400

	# subtract one day to date
	PREVIOUS_DATE=$(date -d "$INITIAL_DATE -$ONE_DAY sec" "+%Y%m%d")

	# return previous date
	echo "${PREVIOUS_DATE}"
}

Dated_archive_entry ()
{
	# returns the link for a specific date
	WANTED_DATE="${1}:-${LB_SNAPSHOT}}"
	DATED_ENTRY="$(cat /tmp/index.html | grep "$(Short_date ${WANTED_DATE})" | sed 's|.*<a href="\([^"]*\)".*$|\1|' | tail -n 1 )"
	echo "$( echo ${DATED_ENTRY} | sed 's|./||' | sed 's|/||' )"
}

Previous_archive_entry ()
{
	# returns the link for the match or the previous entry before specific date
	FIRST_DATE="$(Short_date $(First_archive_entry))"

	DATE="$(Short_date ${LB_SNAPSHOT})"

	# if there is no daily installer available for
	# a very old date, then use the oldest daily installer
	# available, even with kernel mismatch.
	if [ ${DATE} -le ${FIRST_DATE} ]
	then
		DATE=${FIRST_DATE}
	fi

	while [ "${DATE}" != "${FIRST_DATE}" ]; do
		LINK=$(cat /tmp/index.html |  grep "${DATE}" | sed 's|.*<a href="\([^"]*\)".*$|\1|' )

		if [ -z "${LINK}" ]
		then
			# date was not found
			# try previous date
			DATE=$(Previous_date "${DATE}")
		else
			# a link was found
			break
		fi
	done

	# return link to matched date or previous daily installer date,
	# the 1st one if no other younger d-i for that date was found
	Dated_archive_entry "${DATE}"
}

Latest_debian_archive_snapshot_available ()
{
	# returns the complete date/time for the link of the latest (last) available debian archive snapshot date
	wget 'http://snapshot.debian.org/archive/debian/?year='"$(date +%Y)"';month='"$(date +%m)" -O /tmp/index.html && true
	LAST_ARCHIVE_SNAPSHOT="$(Last_archive_entry)"
	echo "${LAST_ARCHIVE_SNAPSHOT}"
}

Dated_debian_archive_snapshot ()
{
	# returns the complete date/time for the link of the latest for a specific date in snapshot.debian.org
	DATE_YEAR="$(Short_date ${LB_SNAPSHOT} | cut -c 1-4 )"
	DATE_MONTH="$(Short_date ${LB_SNAPSHOT} | cut -c 5-6 )"
	wget 'http://snapshot.debian.org/archive/debian/?year='"${DATE_YEAR}"';month='"${DATE_MONTH}" -O /tmp/index.html && true
	LAST_ARCHIVE_SNAPSHOT="$(Dated_archive_entry)"
	echo "${LAST_ARCHIVE_SNAPSHOT}"
}

Latest_debian_installer_snapshot_available ()
{
	# returns the date-hour for the latest date of debian-installer daily build available for an arch
	# d-i archive uses different date links
	wget 'http://d-i.debian.org/daily-images/'"${LIVE_IMAGE_ARCHITECTURE}" -O /tmp/index.html && true
	LAST_INSTALLER_SNAPSHOT="$(Last_archive_entry)"
	echo "${LAST_INSTALLER_SNAPSHOT}"
}

Dated_debian_installer_snapshot ()
{
	# returns the date-hour for the specific date of debian-installer daily build available for an arch
	# d-i archive uses different date links
	wget 'http://d-i.debian.org/daily-images/'"${LIVE_IMAGE_ARCHITECTURE}" -O /tmp/index.html && true
	DATED_INSTALLER_SNAPSHOT="$(Dated_archive_entry)"
	echo "${DATED_INSTALLER_SNAPSHOT}"
}

Available_daily_installer ()
{
	# returns the desired daily d-i date link or the previous existing daily d-i
	DAILY_INSTALLER="$(Dated_debian_installer_snapshot)"
	if [ -z "${DAILY_INSTALLER}" ]
	then
		# no wanted date was found, download available dates and search previous
		wget 'http://d-i.debian.org/daily-images/'"${LIVE_IMAGE_ARCHITECTURE}" -O /tmp/index.html && true
		DAILY_INSTALLER=$(Previous_archive_entry)
	fi

	echo "${DAILY_INSTALLER}"
}
