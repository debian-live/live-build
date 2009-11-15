#!/bin/sh

# This is a hook for live-helper(7) to install nvidia-legacy drivers
# To enable it, copy this hook into your config/chroot_localhooks directory.

# IMPORTANT: for apt-get to locate the required packages you need to
# add "contrib non-free" sections.
#
# e.g with make-live : --sections "main contrib non-free"

# Updating indices
apt-get update

# Building kernel module
which module-assistant || apt-get install --yes module-assistant nvidia-kernel-common
module-assistant update
module-assistant --non-inter --quiet auto-install nvidia-kernel-legacy
module-assistant clean nvidia-kernel-legacy

# Installing aditional stuff
apt-get install --yes nvidia-glx-legacy nvidia-xconfig discover

# fixup (#421028)
if [ -f /usr/lib/xorg/modules/drivers/nvidia_drv.o ]
then
	cd /usr/lib/xorg/modules/drivers
	gcc -shared -o nvidia_drv.so nvidia_drv.o
	cd ${OLDPWD}
fi

# Adding init script
cat > /etc/init.d/nvidia-debian-live << EOF
#!/bin/sh
# script that modify xorg configuration enabling
# the nvidia proprietary module if the card is detected
# as an NVidia

if discover --type-summary display | grep -i nvidia
then
	# forcing depth to 24, bad detection on some card (e.g my GeForce4 440 Go)
	echo "Configuring Xorg for nvidia ..."
	nvidia-xconfig -d 24
else
	# not with nvidia h/w ? remove those GLX diversions
	# (FIXME)
	apt-get --quiet --yes remove nvidia-glx-legacy
fi
EOF

chmod 0755 /etc/init.d/nvidia-debian-live
update-rc.d nvidia-debian-live defaults
