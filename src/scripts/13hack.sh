#!/bin/sh

# make-live - utility to build Debian Live systems
#
# Copyright (C) 2006 Daniel Baumann <daniel@debian.org>
# Copyright (C) 2006 Marco Amadori <marco.amadori@gmail.com>
#
# make-live comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

Hack_xorg ()
{
	if [ -f "${LIVE_CHROOT}/etc/X11/xorg.conf" ]
	then
		# Comment "BusID" line and set driver to "vesa"
		sed -i -e 's/\(^.*BusID.*\)/#\1/g' -e '/Section "Device"/,/EndSection/ s/\(.*Driver.*"\).*\(".*\)/\1vesa\2/g' "${LIVE_CHROOT}"/etc/X11/xorg.conf
	fi
}
