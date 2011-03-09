# Makefile

SHELL := sh -e

LANGUAGES = de

SCRIPTS = cgi/* functions/* examples/*/*.sh scripts/*.sh scripts/*/*

all: test build

test:
	@echo -n "Checking for syntax errors"

	@for SCRIPT in $(SCRIPTS); \
	do \
		sh -n $${SCRIPT}; \
		echo -n "."; \
	done

	@echo " done."

	@# We can't just fail yet on bashisms (FIXME)
	@echo -n "Checking for bashisms"

	@if [ -x /usr/bin/checkbashisms ]; \
	then \
		for SCRIPT in $(SCRIPTS); \
		do \
			checkbashisms -f -x $${SCRIPT} || true; \
			echo -n "."; \
		done; \
	else \
		echo "WARNING: skipping bashism test - you need to install devscripts."; \
	fi

	@echo " done."

build:
	@echo "Nothing to build."

install:
	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live/build
	cp -r cgi data examples functions scripts hooks includes lists repositories templates $(DESTDIR)/usr/share/live/build

	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	mv $(DESTDIR)/usr/share/live/build/scripts/build/lb $(DESTDIR)/usr/share/live/build/scripts/build/live-build $(DESTDIR)/usr/bin

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-build
	cp -r COPYING docs/* $(DESTDIR)/usr/share/doc/live-build

	# Installing manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE}); \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

	# Installing logfile
	mkdir -p $(DESTDIR)/var/log

uninstall:
	# Uninstalling shared data
	rm -rf $(DESTDIR)/usr/share/live/build
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/live

	# Uninstalling executables
	rm -f $(DESTDIR)/usr/bin/lb $(DESTDIR)/usr/bin/live-build

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-build

	# Uninstalling manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		rm -f $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE} .en.$${SECTION}).$${SECTION}; \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			rm -f $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

clean:

distclean:

reinstall: uninstall install
