# Makefile

all:		install

install:
		# Install main script
		install -D -m 755 make-live.sh $(DESTDIR)/usr/sbin/make-live
		install -d -m 755 $(DESTDIR)/usr/share/make-live

		# Install package lists
		cp -a lists $(DESTDIR)/usr/share/make-live

		# Install sub scripts
		cp -a scripts $(DESTDIR)/usr/share/make-live

		# Install configuration templates
		cp -a templates $(DESTDIR)/usr/share/make-live

		# Install manpages
		install -d -m 755 $(DESTDIR)/usr/share/man/man8
		cp -a make-live.8 make-live.conf.8 $(DESTDIR)/usr/share/man/man8

		# Install configuration file
		install -D -m 644 make-live.conf $(DESTDIR)/etc/make-live.conf

uninstall:
		# Remove main script
		rm -rf $(DESTDIR)/usr/sbin/make-live

		# Remove shared data
		rm -rf $(DESTDIR)/usr/share/make-live

		# Remove configuration file
		rm -f $(DESTDIR)/etc/make-live.conf

reinstall:	uninstall install
