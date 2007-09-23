#!/usr/bin/make -f

all: install

test:
	set -e; for SCRIPT in functions/* examples/*.sh helpers/* hooks/*; \
	do \
		sh -n $$SCRIPT; \
	done

install: test
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
	set -e; for MANPAGE in manpages/*.1.en; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man1/`basename $$MANPAGE .en`; \
	done

	set -e; for MANPAGE in manpages/*.7.en; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en`; \
	done

	set -e; for MANPAGE in manpages/*.1.de; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/de/man1/`basename $$MANPAGE .de`; \
	done

	set -e; for MANPAGE in manpages/*.7.de; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/de/man7/`basename $$MANPAGE .de`; \
	done

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
	set -e; for MANPAGE in manpages/*.1.en; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man1/`basename $$MANPAGE .en`; \
	done

	set -e; for MANPAGE in manpages/*.7.en; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en`; \
	done

	set -e; for MANPAGE in manpages/*.1.de; \
	do \
		rm -f $(DESTDIR)/usr/share/man/de/man1/`basename $$MANPAGE .de`; \
	done

	set -e; for MANPAGE in manpages/*.7.de; \
	do \
		rm -f $(DESTDIR)/usr/share/man/de/man7/`basename $$MANPAGE .de`; \
	done

clean:

distclean:

reinstall: uninstall install
