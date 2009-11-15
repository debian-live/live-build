# scripts/00-init.sh

Init ()
{
	# Check if user is root
	if [ "`id -u`" -ne "0" ]
	then
		echo "E: ${PROGRAM} requires superuser privilege."
		exit 1
	fi

	# Check if build directory already exists
	if [ -d "${LIVE_ROOT}" ] && [ ! -d "${LIVE_ROOTFS}" ]
	then
		echo "E: found an (unfinished) system, remove it and re-run ${PROGRAM}."
		exit 1
	fi
}
