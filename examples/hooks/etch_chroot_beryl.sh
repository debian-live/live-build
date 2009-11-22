#!/bin/sh

# This is a hook for live-helper(7) to install beryl and enable aiglx.
# It was originally written by Inigo Tejedor Arrondo <inigo@navarrux.org>.
#
# To enable it, copy or symlink this hook into your config/chroot_local-hooks
# directory.
#
# For forcing aiglx activation type at boot prompt "live forceaiglx".
# For forcing aiglx deactivation type "live noaiglx".

# Importing archive signing key
wget -O - http://debian.beryl-project.org/root@lupine.me.uk.gpg | apt-key add -

# Updating indices
apt-get update

# Installing packages
PACKAGES="beryl beryl-core beryl-manager beryl-plugins beryl-settings beryl-settings-bindings beryl-settings-simple mesa-utils"

dpkg -s gnome-core > /dev/null 2>&1 && PACKAGES="${PACKAGES} emerald emerald-themes heliodor"
dpkg -s kde-core   > /dev/null 2>&1 && PACKAGES="${PACKAGES} aquamarine"

apt-get install --yes ${PACKAGES}

# Adding init script
cat > /etc/init.d/aiglx << EOF
#!/bin/sh
activate_3d()
{
	activate_aiglx
	activate_beryl
}

activate_aiglx()
{
	echo "" >> /etc/X11/xorg.conf
	echo "# Added by beryl-hook.sh" >> /etc/X11/xorg.conf
	echo "Section \"Extensions\"" >> /etc/X11/xorg.conf
	echo " Option \"Composite\" \"Enable\"" >> /etc/X11/xorg.conf
	echo "EndSection" >> /etc/X11/xorg.conf

	sed -i -e "s/Section \"Device\""/"Section \"Device\"\n\t Option \"XAANoOffscreenPixmaps\" \"true\"\n\t Option \"AddARGBGLXVisuals\" \"on\"\n\t Option \"AllowGLXWithComposite\" \"true\"/" -e "s/Section \"Module\""/"Section \"Module\"\n\t Load \"i2c\"\n\t Load \"int10\"\n\t Load \"xtrap\"\n\t Load \"vbe\"/" /etc/X11/xorg.conf
}

activate_beryl()
{
	# http://standards.freedesktop.org/autostart-spec/autostart-spec-latest.html
	! [ -d /etc/xdg/autostart ] && mkdir -p /etc/xdg/autostart

cat > /etc/xdg/autostart/beryl-manager.desktop << EOS
[Desktop Entry]
Encoding=UTF-8
Name=Beryl Manager
GenericName=3D Window Manager
Comment=Beryl Manager daemon
Icon=
Exec=beryl-starter
Terminal=false
Type=Application
Categories=
EOS

cat > /usr/local/bin/beryl-starter << EOS
#!/bin/sh
glxinfo > /dev/null 2>&1 && beryl-manager
EOS

chmod 0755 /usr/local/bin/beryl-starter
}

if ! cat /proc/cmdline | grep noaiglx > /dev/null
then
	echo "Configuring xorg for aiglx..."
	activate_3d
fi
EOF

chmod 0755 /etc/init.d/aiglx
update-rc.d aiglx defaults
