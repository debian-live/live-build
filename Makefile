# Makefile

#TRANSLATIONS="de"

all: build

test:
	# Checking for syntax errors
	set -e; for SCRIPT in functions/* examples/*/*.sh helpers/* hooks/*; \
	do \
		sh -n $$SCRIPT; \
	done

	# Checking for bashisms
	set -e; if [ -x /usr/bin/checkbashisms ]; \
	then \
		checkbashisms functions/* examples/*/*.sh helpers/* hooks/*; \
	else \
		echo "bashism test skipped - you need to install devscripts."; \
	fi

build:
	@echo "Nothing to build."

install:
	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	cp helpers/lh* $(DESTDIR)/usr/bin

	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live-helper
	cp -r data examples functions hooks includes lists templates $(DESTDIR)/usr/share/live-helper

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-helper
	cp -r COPYING docs/* $(DESTDIR)/usr/share/doc/live-helper

	# Installing manpages
	set -e; for MANPAGE in manpages/*.en.1; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man1/`basename $$MANPAGE .en.1`.1; \
	done

	set -e; for MANPAGE in manpages/*.en.7; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en.7`.7; \
	done

	set -e; for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.1; \
		do \
			install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/$$TRANSLATION/man1/`basename $$MANPAGE .$$TRANSLATION.1`.1; \
		done; \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/`basename $$MANPAGE .$$TRANSLATION.7`.7; \
		done; \
	done

	# Installing logfile
	mkdir -p $(DESTDIR)/var/log

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
	set -e; for MANPAGE in manpages/*.en.1; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man1/`basename $$MANPAGE .en.1`.1; \
	done

	set -e; for MANPAGE in manpages/*.en.7; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en.7`.7; \
	done

	set -e; for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.1; \
		do \
			rm -f $(DESTDIR)/usr/share/man/$$TRANSLATION/man1/`basename $$MANPAGE .$$TRANSLATION.1`.1; \
		done; \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			rm -f $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/`basename $$MANPAGE .$$TRANSLATION.7`.7; \
		done; \
	done

update:
	set -e; for FILE in functions/*.sh examples/cron/*.sh manpages/*.en.*; \
	do \
		sed -i	-e 's/2007\\-11\\-26/2007\\-12\\-03/' \
			-e 's/26.11.2007/03.12.2007/' \
			-e 's/1.0~a38/1.0~a39/' \
		$$FILE; \
	done

clean:

distclean:

reinstall: uninstall install

po4a:
	# Automatic generation of translated manpages
	set -e; if [ $$(which po4a) ]; then \
	  cd manpages/ ; po4a po4a/live-helper.cfg; \
	else \
	  echo "Please install po4a (http://po4a.alioth.debian.org/)."; \
	fi;
