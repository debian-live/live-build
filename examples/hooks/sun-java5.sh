#!/bin/sh

# This is a hook for live-helper(7) to install sun-java.
# To enable it, copy this hook into your config/chroot_local-hooks directory.
#
# Note: This hook requires packages from the non-free category. Make sure you
# enabled it in your configuration.

# live-helper sets DEBIAN_FRONTEND to 'noninteractive' to advise debconf to not
# ask any questions while installing packages. Suns redistribution terms for
# Java do not allow this, therefore we need to overwrite DEBIAN_FRONTEND for
# this apt-get call only.

# In case you do accept the license terms, you can also preseed the values
# for a complete non-interactive build, by uncommenting the following three lines:

#echo "sun-java5-bin shared/accepted-sun-dlj-v1-1 boolean true" > /root/preseed
#debconf-set-selections < /root/preseed
#rm -f /root/preseed

DEBIAN_FRONTEND="dialog" apt-get install --yes sun-java5-bin sun-java5-demo \
	sun-java5-doc sun-java5-fonts sun-java5-jdk sun-java5-jre \
	sun-java5-plugin sun-java5-source
