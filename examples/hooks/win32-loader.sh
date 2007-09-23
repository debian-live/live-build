#!/bin/sh

# This is a hook for live-helper(7) to install win32-loader.
# win32-loader was written by Robert Milan <rmh@aybabtu.com>.
#
# To enable it, copy this hook into your config/binary_local-hooks directory.

cd binary

wget http://goodbye-microsoft.com/pub/debian.exe

cd "${OLDPWD}"
