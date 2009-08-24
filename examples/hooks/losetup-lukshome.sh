#!/bin/sh

# This hook was based and adapted from:
# http://lists.debian.org/debian-live/2009/04/msg00186.html
# ---------------------------------------------------------
#
#
# NOTE 1: this was not tested with persistent boot option,
# but it seems logic that persistent and lukshome can't
# coexist as boot options (because of snapshots and others), so lukshome
# won't be executed if any persistent option is given on boot.
#
# NOTE 2: if using an USB key, it will eventualy end up failing someday.
# You should backup regularly the data on the encrypted file or the
# disk image file itself (luks-home.img) to prevent loosing data.
#
# This hook will create 3 files:
#
# /usr/local/sbin/create-lukshome-file.sh
#	script to create an disk file image (luks-home.img) with a
#	LUKS encrypted ext2 filesystem inside to be placed in a
#	partition labeled lukshome.
#
# /usr/local/sbin/lukshome.sh
#	detects a partition with lukshome label, updates fstab and crypttab so
#	the encrypted file is mounted later in a loopback device (/dev/loopX).
#	It also changes /etc/init.d/umountfs so the encrypted home is correctly
#	umounted.
#
# /usr/share/initramfs-tools/scripts/live-bottom/13live_luks_home
#	a live-initramfs hook to execute lukshome.sh script
#	in initrd.
#
#
# HOWTO lukshome
# --------------
#
# First build your live system with this hook present in
# config/chroot_local-hooks/. If you have an existing live-helper build directory
# with a previous live build, you might have to run:
#
#	lh_clean
#	lh_clean --stage
#
# to make sure this hook is included in the live system. Then (re)build your live system.
#
# Boot your live system normally and run as root or with sudo:
#
#	sudo -i
#	create-lukshome-file.sh
#	# the script is located in /usr/local/sbin/, so it's in root $PATH.
#
# This script will create the disk file image with an encrypted filesystem for you.
#
# Then copy the file to a partition (on USB pen or harddisk) and label that partition with
# lukshome.
#
####### THIS CAN WIPE YOUR DATA, backup first!
####### Be sure to understand what you will do, or you can end up
####### wiping disks or partitions you don't want to.
#
#	# Here we are using ext2 (no journaling), but any partition
#	# format that Debian Live *can* mount *should* work.
#	# The partition labeled lukshome is very important!
#	mkfs.ext2 -L lukshome /dev/the_partition_to_be_used
#	mount /dev/the_partition_to_be_used /mnt
#	cp luks-home.img /mnt
#	umount /mnt
#
# Reboot and now use the lukshome boot option to mount the encrypted /home, like in
# persistent=nofiles with a home-rw file/partition.
#



echo "I: creating script /usr/local/sbin/create-lukshome-file.sh"
cat > /usr/local/sbin/create-lukshome-file.sh << 'EOF'
#!/bin/sh

# Script to create an encrypted filesystem in a disk file image to
# be used in a Debian Live Helper built live system with lukshome hook.

# check if root/sudo
if [ "${USER}" != "root" ]
then
	echo " ** Please run this script as root or with sudo."
	echo ""
	exit 1
fi

# check if /mnt is available
mount | grep "/mnt" > /dev/null
MNT_IS_MOUNTED=${?}
if [ "${MNT_IS_MOUNTED}" == 0 ]
then
	echo "** ERROR: /mnt is mounted at the moment. Please umount it to use this script."
	exit 1
fi

# check if /dev/mapper/luks-home is available
if [ -f /dev/mapper/luks-home ]
then
	echo "** ERROR: /dev/mapper/luks-home is being used at the moment. Please run «cryptsetup remove luks-home» to use this script."
	exit 1
fi

# create file
echo ""
echo "** Please type the size of the file disk image."
echo "Size of the file in MB: "
read FILE_SIZE

echo ""
echo "** Creating file."
echo "** Filling file image with /dev/urandom output. It will take some time."
echo "(Please change this script to use /dev/random instead. It's more secure but will take a *very* long time to complete."
dd if=/dev/urandom of=luks-home.img bs=1M count=${FILE_SIZE}
echo "** Done."
echo ""

# losetup
FREE_LOSETUP=$(losetup -f)
echo "** Using ${FREE_LOSETUP} to open luks-home.img"
losetup ${FREE_LOSETUP} ./luks-home.img
echo "** Done."
echo ""

# cryptsetup
echo "** Running cryptsetup."
echo ""
echo "** luksFormat"
cryptsetup luksFormat ${FREE_LOSETUP}
ERROR_LEVEL=${?}
if [ "${ERROR_LEVEL}" != 0 ]
then
	echo "** ERROR: Error while trying to format disk file image."
	losetup -d ${FREE_LOSETUP}
	exit 1
fi
echo ""

echo "** luksOpen"
cryptsetup luksOpen ${FREE_LOSETUP} luks-home
ERROR_LEVEL=${?}
if [ "${ERROR_LEVEL}" != 0 ]
then
	echo "** ERROR: Error while trying to open LUKS file image."
	losetup -d ${FREE_LOSETUP}
	exit 1
fi
echo ""

# format encrypted filesystem
echo "** Now formating /dev/mapper/luks-home"
mkfs.ext2 /dev/mapper/luks-home
ERROR_LEVEL=${?}
if [ "${ERROR_LEVEL}" != 0 ]
then
	echo "** ERROR: Error while trying to format LUKS file."
	losetup -d ${FREE_LOSETUP}
	exit 1
fi
echo ""

# mount in /mnt
echo "** Now mounting luks-home.img in /mnt"
mount /dev/mapper/luks-home /mnt
ERROR_LEVEL=${?}
if [ "${ERROR_LEVEL}" != 0 ]
then
	echo "** ERROR: Error while trying to mount LUKS file in /mnt."
	umount /mnt
	losetup -d ${FREE_LOSETUP}
	exit 1
fi
echo ""

# copy files
echo "** To copy the actual /home/* directory to the encrypted disk image filesystem, press ENTER and"
echo "** answer -> Y <- when asked to confirm."
echo ""
echo "** If using an other external /home partition be aware that UID and username must match with the ones used by the live system."
echo "** If you don't want to copy anything now, just press ENTER twice. No copying will be done, file will be an empty encrypted ext2 filesystem."
echo "** Later, after this script ends, use losetup, cryptsetup, mount and chown to copy manually the files/directory you want."
echo ""
echo "** Please type the location of /home directories to be copied."
echo "Where are the directiories you want to copy? [/home/*]"
read HOME_DIR

if [ -z "${HOME_DIR}" ]
then
	HOME_DIR="/home/*"
fi

echo "** Please confirm. Press ENTER if you don't want any file to be copied now."
echo "Copy directories and files from "${HOME_DIR}"? (y/N)"
read CONFIRM_COPY

case "${CONFIRM_COPY}" in
	y*|Y*)
		echo "** Copying from ${HOME_DIR}."
		cp -rav ${HOME_DIR} /mnt
		ERROR_LEVEL=${?}
		if [ "${ERROR_LEVEL}" != 0 ]
		then
			echo "** ERROR: Error while trying to copy files to /mnt."
			umount /mnt
			losetup -d ${FREE_LOSETUP}
			exit 1
		fi
		echo "** Done."
		echo ""
	;;
	*)
		echo "Not copying anything."
		echo ""
	;;
esac

echo "** All done."
echo "** Closing losetup, cryptsetup and mounted /mnt."
# umount and close
umount /mnt
cryptsetup remove luks-home
losetup -d ${FREE_LOSETUP}
echo "** The disk file image luks-home.img is done and ready."
echo ""

EOF

chmod 0755 /usr/local/sbin/create-lukshome-file.sh



echo "I: creating script /usr/local/sbin/lukshome.sh"

cat > /usr/local/sbin/lukshome.sh << 'EOF'
#!/bin/sh

# this script is executed by a hook in live-initramfs. It searches
# for an ext2 partition with lukshome label, mounts loop file and saves location
# in /etc/live.conf. It also creates a script in /etc/init.d/ for umounting /home on shutdown.

# functions taken from live-helpers
. /usr/share/initramfs-tools/scripts/live-helpers

# search for a partition labeled "lukshome"
for sysblock in $(echo /sys/block/* | tr ' ' '\n' | grep -v loop | grep -v ram | grep -v fd)
do
	for dev in $(subdevices "${sysblock}")
	do
		devname=$(sys2dev "${dev}")
		# find partition name and filesystem type
		if [ "$(/lib/udev/vol_id -l ${devname} 2>/dev/null)" = "lukshome" ]
		then
			# found one partition named "lukshome"
			CRYPTHOME="${devname}"
			# don't search further
			break
		fi
	done
	# if already found, don't search further
	if [ -n "${CRYPTHOME}" ]
	then
		break
	fi
done

# if no partition found, exit
if [ -z "${CRYPTHOME}" ]
then
	echo "Could not find any partition with lukshome label."
	exit 0
fi

# mount partition where file container is
echo "Mounting /luks-home with ${CRYPTHOME}."
mkdir -p /luks-home
mount -t $(get_fstype "${CRYPTHOME}") "${CRYPTHOME}" /luks-home

# mount losetup encrypted file
FREE_LOOP="$(/sbin/losetup -f)"
echo "Mounting /luks-home/luks-home.img in ${FREE_LOOP}."

if [ -f /luks-home/luks-home.img ]
then
	/sbin/losetup ${FREE_LOOP} /luks-home/luks-home.img

	echo "Adding ${FREE_LOOP} home to /etc/crypttab and setting it as /home in /etc/fstab."

	# update crypttab
	echo "home	${FREE_LOOP}	none	luks,check,timeout" >> /etc/crypttab

	# update fstab
	echo "/dev/mapper/home	/home	ext2	defaults,noatime	0	0" >> /etc/fstab
fi

# changes to /etc/init.d/umountfs to make /luks-home been umounted too
sed -i 's/[\t]do_stop/CHANGE_HERE/' /etc/init.d/umountfs
sed -i 's|CHANGE_HERE|	\
	# added by lukshome hook -  umount \/luks-home to prevent busy device on shutdown \
	LOOP_LUKSHOME=$(losetup -a \| grep luks-home \|cut -c 1-10) \
	if [ -n ${LOOP_LUKSHOME} ] \
	then \
		umount -r -d \/home \
		cryptsetup remove home \
		losetup -d ${LOOP_LUKSHOME} \
		umount -r \/luks-home \
	fi \
\
	do_stop \
|' /etc/init.d/umountfs

EOF

chmod 0755 /usr/local/sbin/lukshome.sh



# scripts/live-bottom/13live_luks_home, right after 12fstab
echo "I: creating /usr/share/initramfs-tools/scripts/live-bottom/13live_luks_home"

cat > /usr/share/initramfs-tools/scripts/live-bottom/13live_luks_home << 'EOF'
#!/bin/sh

#set -e

# initramfs-tools header

PREREQ=""

prereqs()
{
	echo "${PREREQ}"
}

case "${1}" in
	prereqs)
		prereqs
		exit 0
		;;
esac

. /scripts/live-functions

# live-initramfs hook to add the lukshome partition to crypttab and fstab

log_begin_msg "Executing losetup-lukshome"

# get boot option lukshome without persistent- adapted from live-helpers
for ARGUMENT in $(cat /proc/cmdline)
do
	case "${ARGUMENT}" in
		lukshome)
			LUKSHOME=1
			;;
	esac
done

# don't use persistent* and lukshome
if [ -n "${PERSISTENT}" ] && [  -n "${LUKSHOME}" ]
then
	echo "You should not use persistent and lukshome at the same time."
	echo "Skipping lukshome. Persistent medium will be used instead."
	log_end_msg
	exit 0
fi

# if no lukshome boot option, exit
if [ -z "${LUKSHOME}" ]
then
	echo "Nothing to do."
	log_end_msg
	exit 0
fi

log_begin_msg "Executing lukshome.sh script."

mount -o bind /sys /root/sys
mount -o bind /proc /root/proc
mount -o bind /dev /root/dev

# lukshome.sh detects lukshome partition and file location, mounts it
# and updates fstab and crypttab.
chroot /root /usr/local/sbin/lukshome.sh

umount /root/sys
umount /root/proc
umount /root/dev

# delete the lukshome scripts, not needed anymore
# rm -f /root/usr/local/sbin/lukshome.sh
# rm -f /root/usr/local/sbin/create-lukshome-file.sh

log_end_msg

EOF

chmod 0755 /usr/share/initramfs-tools/scripts/live-bottom/13live_luks_home



echo "I: update-initramfs to include 13live_luks_home."
# if you already have installed the update-initramfs.sh hook, you can remove this.

for KERNEL in /boot/vmlinuz-*
do
	VERSION="$(basename ${KERNEL} | sed -e 's|vmlinuz-||')"

	update-initramfs -k ${VERSION} -t -u
done
