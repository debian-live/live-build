#!/bin/sh

# This is a hook for live-helper(7) to install autorun4linuxCD.
# autorun4linuxCD was written by Franklin Piat <fpiat@bigfoot.com>.
#
# To enable it, copy this hook into your config/binary_local-hooks directory.

cd binary
wget http://www.klabs.be/~fpiat/projects/autorun4linuxCD/autorun4linuxCD.tar.gz
