# Makefile

all:	install

install:
	# Installing make-live
	@# Install main script
	install -D -m 0755 src/main.sh $(DESTDIR)/usr/sbin/make-live

	@# Install configuration file
	install -D -m 0644 src/config $(DESTDIR)/etc/make-live.conf

	@# Install package lists
	install -d -m 0755 $(DESTDIR)/usr/share/make-live/lists
	install -m 0644 src/lists/* $(DESTDIR)/usr/share/make-live/lists

	@# Install flavour hooks
	install -d -m 0755 $(DESTDIR)/usr/share/make-live/hooks
	install -m 0644 src/hooks/* $(DESTDIR)/usr/share/make-live/hooks

	@# Install sub scripts
	install -d -m 0755 $(DESTDIR)/usr/share/make-live/scripts
	install -m 0755 src/scripts/*.sh $(DESTDIR)/usr/share/make-live/scripts

	@# Install templates
	cp -r templates $(DESTDIR)/usr/share/make-live

	@# Install documentation
	install -d -m 0755 $(DESTDIR)/usr/share/doc/live-package
	install -m 0644 doc/*.txt $(DESTDIR)/usr/share/doc/live-package

	@# Install manpages
	install -d -m 0755 $(DESTDIR)/usr/share/man/man8
	install -m 0644 doc/man/*.8  $(DESTDIR)/usr/share/man/man8

uninstall:
	# Uninstalling make-live
	@# Remove main script
	rm -f $(DESTDIR)/usr/sbin/make-live

	@# Remove configuration file
	rm -f $(DESTDIR)/etc/make-live.conf

	@# Remove shared data
	rm -rf $(DESTDIR)/usr/share/make-live

	@# Remove documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-package

	@# Remove manpages
	rm -f $(DESTDIR)/usr/share/man/man8/make-live.*

reinstall:	uninstall install
