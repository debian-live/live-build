#!/bin/sh

# This is a hook for live-helper(7) to install beryl and enable aixgl.
# It was originally written by Inigo Tejedor Arrondo <inigo@navarrux.org>.
#
# To enable it, copy this hook into your config/chroot_localhooks directory.
# At boot prompt, type 'live aixgl', press enter and have fun.

# Import archive signing key
wget -O - http://debian.beryl-project.org/root@lupine.me.uk.gpg | apt-key add -

# Update indices
apt-get update

# Install packages
PACKAGES="beryl beryl-core beryl-manager beryl-plugins beryl-settings beryl-settings-bindings beryl-settings-simple"
#beryl-plugins-unsupported

if [ -f /usr/bin/gnome-session ]
then
	PACKAGES="${PACKAGES} emerald emerald-themes heliodor"
fi

if [ -f /usr/bin/kstart ]
then
	PACKAGES="${PACKAGES} aquamarine"
fi

apt-get install --yes ${PACKAGES}

# Add init script
cat > /etc/init.d/aixgl << EOF
#!/bin/sh

if cat /proc/cmdline | grep aixgl > /dev/null
then
	echo "Configuring xorg for aixgl..."

	echo "" >> /etc/X11/xorg.conf
	echo "# Added by beryl-hook.sh" >> /etc/X11/xorg.conf
	echo "Section \"Extensions\"" >> /etc/X11/xorg.conf
	echo " Option \"Composite\" \"Enable\"" >> /etc/X11/xorg.conf
	echo "EndSection" >> /etc/X11/xorg.conf

	sed -i -e "s/Section \"Device\""/"Section \"Device\"\n\t Option \"XAANoOffscreenPixmaps\" \"true\"\n\t Option \"AddARGBGLXVisuals\" \"on\"\n\t Option \"AllowGLXWithComposite\" \"true\"/" -e "s/Section \"Module\""/"Section \"Module\"\n\t Load \"i2c\"\n\t Load \"int10\"\n\t Load \"xtrap\"\n\t Load \"vbe\"/" /etc/X11/xorg.conf
fi
EOF

chmod 0755 /etc/init.d/aixgl
update-rc.d aixgl defaults
