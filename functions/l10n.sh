#!/bin/sh

# l10n.sh - load the needed localization things for all lh messages
# Copyright (C) 2006-2008 Daniel Baumann <daniel@debian.org>
#
# live-helper comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
# This is free software, and you are welcome to redistribute it
# under certain conditions; see COPYING for details.

set -e

# gettext domain (.mo file name)
export TEXTDOMAIN=live-helper
# locale dir for gettext codes
export TEXTDOMAINDIR=/usr/share/locale
# load gettext functions
. gettext.sh
