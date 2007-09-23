#!/usr/bin/make -f

all:	install

install:
	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	cp helpers/lh_* helpers/make-live $(DESTDIR)/usr/bin

	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live-helper
	cp -r examples functions hooks includes lists templates $(DESTDIR)/usr/share/live-helper

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-helper
	cp -r COPYING doc/* $(DESTDIR)/usr/share/doc/live-helper

	# Installing manpages
	mkdir -p $(DESTDIR)/usr/share/man/man1
	cp manpages/*.1 $(DESTDIR)/usr/share/man/man1

	mkdir -p $(DESTDIR)/usr/share/man/man7
	cp manpages/*.7 $(DESTDIR)/usr/share/man/man7

uninstall:
	# Uninstalling executables
	for HELPER in helpers/*; \
	do \
		rm -f $(DESTDIR)/usr/bin/`basename $$HELPER`; \
	done

	# Uninstalling shared data
	rm -rf $(DESTDIR)/usr/share/live-helper

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-helper

	# Uninstalling manpages
	for MANPAGE in manpages/*.1; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man1/`basename $$MANPAGE`; \
	done

	for MANPAGE in manpages/*.7; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE`; \
	done

clean:

reinstall:      uninstall install
