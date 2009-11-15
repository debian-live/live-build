# scripts/00-defaults.sh

Defaults ()
{
	# Set architecture name
	if [ -z "${LIVE_ARCHITECTURE}" ]
	then
		LIVE_ARCHITECTURE="`dpkg-architecture -qDEB_BUILD_ARCH`"
	fi

	# Set build directory
	if [ -z "${LIVE_ROOT}" ]
	then
		LIVE_ROOT="`pwd`/live"
	fi

	# Set rootfs directory 
	if [ -d  "${LIVE_ROOTFS}" ]
	then
		LIVE_CHROOT="${LIVE_ROOTFS}"
	else
		LIVE_CHROOT="${LIVE_ROOT}/chroot"
	fi

	# Set distribution name
	if [ -z "${LIVE_DISTRIBUTION}" ]
	then
		LIVE_DISTRIBUTION="unstable"
	fi

	# Set bootstrap flavour
	if [ -z "${LIVE_FLAVOUR}" ]
	then
		LIVE_FLAVOUR="standard"
	fi

	# Set linux-image flavour
	if [ -z "${LIVE_LINUX}" ]
	then
		case "${LIVE_ARCHITECTURE}" in
			alpha)
				LIVE_LINUX="alpha-generic"
				;;

			amd64)
				if [ "${LIVE_DISTRIBUTION}" == unstable ]
				then
					LIVE_LINUX="amd64-k8"
				else
					LIVE_LINUX="amd64-generic"
				fi
				;;

			arm)
				echo "E: You need to specify the linux flavour."
				exit 1
				;;

			hppa)
				LIVE_LINUX="parisc"
				;;

			i386)
				LIVE_LINUX="486"
				;;

			ia64)
				LIVE_LINUX="itanium"
				;;

			m68k)
				echo "E: You need to specify the linux flavour."
				exit 1
				;;

			powerpc)
				LIVE_LINUX="powerpc"
				;;

			s390)
				LIVE_LINUX="s390"
				;;

			sparc)
				LIVE_LINUX="sparc32"
				;;

			*)
				echo "FIXME: Architecture not yet supported."
				exit 1
				;;
		esac
	fi

	# Set logfile
	if [ -z "${LIVE_LOGFILE}" ]
	then
		LIVE_LOGFILE="${LIVE_ROOT}/make-live.log"
	fi

	# Set mirror server
	if [ -z "${LIVE_MIRROR}" ]
	then
		LIVE_MIRROR="http://ftp.debian.org/debian"
	fi

	# Set package list
	if [ -z "${LIVE_PACKAGE_LIST}" ] && [ ! -z "${LIVE_LIST}" ]
	then
		LIVE_PACKAGE_LIST="/usr/share/make-live/lists/${LIVE_LIST}"
	fi

	# Set sections names
	if [ -z "${LIVE_SECTIONS}" ]
	then
		LIVE_SECTIONS="main"
	fi

	# Set templates directory
	if [ ! -z "${LIVE_TEMPLATES}" ]
	then
		if [ ! -d "${LIVE_TEMPLATES}" ]
		then
			echo "E: ${LIVE_TEMPLATES} is not a directory."
			exit 1
		fi
	else
		LIVE_TEMPLATES="/usr/share/make-live/templates"
	fi
}
