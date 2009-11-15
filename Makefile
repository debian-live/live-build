# Makefile

SHELL := sh -e

#TRANSLATIONS="de"

all: test install

test:
	# Checking for syntax errors
	for SCRIPT in live-helper.sh functions/* examples/*/*.sh helpers/* hooks/*; \
	do \
		sh -n $$SCRIPT; \
	done

	# Checking for bashisms
	if [ -x /usr/bin/checkbashisms ]; \
	then \
		checkbashisms live-helper.sh functions/* examples/*/*.sh helpers/* hooks/*; \
	else \
		echo "WARNING: skipping bashism test - you need to install devscripts."; \
	fi

build:
	@echo "Nothing to build."

install:
	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live-helper
	cp -r data examples live-helper.sh functions helpers hooks includes lists templates $(DESTDIR)/usr/share/live-helper

	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	mv $(DESTDIR)/usr/share/live-helper/helpers/lh $(DESTDIR)/usr/share/live-helper/helpers/live-helper $(DESTDIR)/usr/bin

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-helper
	cp -r COPYING docs/* $(DESTDIR)/usr/share/doc/live-helper

	# Installing manpages
	for MANPAGE in manpages/*.en.1; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man1/$$(basename $$MANPAGE .en.1).1; \
	done

	for MANPAGE in manpages/*.en.7; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man7/$$(basename $$MANPAGE .en.7).7; \
	done

	for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.1; \
		do \
			install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/$$TRANSLATION/man1/$$(basename $$MANPAGE .$$TRANSLATION.1).1; \
		done; \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/$$(basename $$MANPAGE .$$TRANSLATION.7).7; \
		done; \
	done

	# Installing logfile
	mkdir -p $(DESTDIR)/var/log

uninstall:
	# Uninstalling shared data
	rm -rf $(DESTDIR)/usr/share/live-helper

	# Uninstalling executables
	rm -f $(DESTDIR)/usr/bin/lh $(DESTDIR)/usr/bin/live-helper

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-helper

	# Uninstalling manpages
	for MANPAGE in manpages/*.en.1; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man1/$$(basename $$MANPAGE .en.1).1*; \
	done

	for MANPAGE in manpages/*.en.7; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man7/$$(basename $$MANPAGE .en.7).7*; \
	done

	for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.1; \
		do \
			rm -f $(DESTDIR)/usr/share/man/$$TRANSLATION/man1/$$(basename $$MANPAGE .$$TRANSLATION.1).1*; \
		done; \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			rm -f $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/$$(basename $$MANPAGE .$$TRANSLATION.7).7*; \
		done; \
	done

clean:

distclean:

reinstall: uninstall install

po4a:
	# Automatic generation of translated manpages
	if [ $$(which po4a) ]; \
	then \
		cd manpages; \
		po4a po4a/live-helper.cfg; \
	else \
		echo "ERROR: skipping po generation - you need to install po4a <http://po4a.alioth.debian.org/>."; \
	fi
