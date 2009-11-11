#!/bin/sh

echo "BINARY-HOOK: fix install from USB in Lenny."

# This is a *binary-hook* to allow disk installations from USB for
# Debian 5.0.x Lenny. Place this file in config/binary_local-hooks/,
# make it executable and rebuild your live image (binary only).

# This workaround for debian-installer was adapted from Chris Lamb
original patch:
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=498143#5

# It works by fooling apt-setup. With an existing /hd-media directory
# apt-setup will not try to umount /cdrom. Enable live installer with
# lh_config:
#
# lh_config --debian-installer "live"
#
# Rebuild your binary image. No options needed on boot.

cat > cdrom-detect.postinst.patch << 'EOF'
@@ -44,6 +44,30 @@ do
 		fi
 	done
 
+	# Try disk partitions masquerading as Debian CDs for Debian Live
+	# "usb-hdd" images. Only vfat and ext are supported.
+	modprobe vfat >/dev/null 2>&1 || true
+	for device in $(list-devices partition); do
+		if mount -t vfat -o ro,exec $device /cdrom ||
+		   mount -t ext2 -o ro,exec $device /cdrom; then
+			log "Pseudo CD-ROM mount succeeded: device=$device"
+
+			# Test whether it's a Debian CD
+			if [ -e /cdrom/.disk/info ]; then
+				mounted=1
+				db_set cdrom-detect/cdrom_device $device
+				# fake hd-media install so that apt-setup doesn't break.
+				mkdir /hd-media
+				break
+			else
+				log "Ignoring pseudo CD-ROM device $device - it is not a Debian CD"
+				umount /cdrom 2>/dev/null || true
+			fi
+		else
+			log "Psuedo CD-ROM mount failed: device=$device"
+		fi
+	done
+
 	if [ "$mounted" = "1" ]; then
 		break
 	fi

EOF

# for the syslinux installer
mkdir usb-install-syslinux
cd usb-install-syslinux
zcat ../binary/install/initrd.gz | cpio -iv
patch ./var/lib/dpkg/info/cdrom-detect.postinst < ../cdrom-detect.postinst.patch
PATCH_ERROR=${?}
if [ "${PATCH_ERROR}" != 0 ]
then
	# if there was an error, say it and undo everything.
	echo "ERROR: error while patching cdrom-detect.postinst."
	cd ..
	rmdir -rf usb-install-syslinux
	exit 0
fi
# rebuild the initrd
find . -print0 | cpio -0 -H newc -ov | gzip -c > ../initrd-new.gz
cd ..
mv initrd-new.gz binary/install/initrd.gz
rm -rf usb-install-syslinux

# for the gtk installer
mkdir usb-install-gtk
cd usb-install-gtk
zcat ../binary/install/gtk/initrd.gz | cpio -iv
patch ./var/lib/dpkg/info/cdrom-detect.postinst < ../cdrom-detect.postinst.patch
PATCH_ERROR=${?}
if [ "${PATCH_ERROR}" != 0 ]
then
	# if there was an error, say it and undo everything
	echo "ERROR: error while patching cdrom-detect.postinst."
	cd ..
	rmdir -rf usb-install-gtk
	exit 0
fi
# rebuild the initrd
find . -print0 | cpio -0 -H newc -ov | gzip -c > ../initrd-new.gz
cd ..
mv initrd-new.gz binary/install/gtk/initrd.gz
rm -rf usb-install-gtk

rm cdrom-detect.postinst.patch
