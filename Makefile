#!/usr/bin/make -f

all:	install

install:
	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	cp helpers/lh_* helpers/make-live $(DESTDIR)/usr/bin

	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live-helper
	cp -r functions hooks includes lists templates $(DESTDIR)/usr/share/live-helper

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-helper
	cp -r COPYING doc/* $(DESTDIR)/usr/share/doc/live-helper

uninstall:
	# Uninstalling executables
	rm -f $(DESTDIR)/usr/bin/lh_* $(DESTDIR)/usr/bin/make-live

	# Uninstalling shared data
	rm -rf $(DESTDIR)/usr/share/live-helper

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-helper

clean:

reinstall:      uninstall install
