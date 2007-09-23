#!/bin/sh

# version.sh - print version information
# Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

Version ()
{
	echo "${PROGRAM}, version ${VERSION}"
	echo "This program is a part of live-helper."
	echo
	echo "Copyright (C) 2006-2007 Daniel Baumann <daniel@debian.org>"
	echo
	echo "This program is free software; you can redistribute it and/or modify"
	echo "it under the terms of the GNU General Public License as published by"
	echo "the Free Software Foundation; either version 2 of the License, or"
	echo "(at your option) any later version."
	echo
	echo "This program is distributed in the hope that it will be useful,"
	echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
	echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the"
	echo "GNU General Public License for more details."
	echo
	echo "You should have received a copy of the GNU General Public License"
	echo "along with this program; if not, write to the Free Software"
	echo "Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA"
	echo
	echo "On Debian systems, the complete text of the GNU General Public License"
	echo "can be found in /usr/share/common-licenses/GPL file."
	echo
	echo "Homepage: <http://debian-live.alioth.debian.org/>"

	exit 0
}
