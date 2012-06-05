# Makefile to manage gettext files

DOMAIN=live-build
ECHO_FUNCTIONS="Echo Echo_debug Echo_debug_running Echo_error Echo_message Echo_message_running Echo_verbose Echo_verbose_running Echo_warning Echo_status Echo_done Echo_file Echo_breakage"

POFILES=$(wildcard *.po)
MOFILES=$(patsubst %.po,%.mo,$(POFILES))
LINGUAS=$(basename $(POFILES))
GETTEXTFILES=$(shell find ../scripts/build ../functions -type f)
POTFILE=$(DOMAIN).pot
DESTDIR=/
XGETTEXT_KEYWORDS=$(shell echo $(ECHO_FUNCTIONS) |sed -e 's,\S\+,-k&,g')

%.mo: %.po
	msgfmt --statistics -o $@ $<

%.po: $(DOMAIN).pot
	msgmerge -U $*.po $(DOMAIN).pot

$(DOMAIN).pot: $(GETTEXTFILES)
	$(shell xgettext $(XGETTEXT_KEYWORDS) -L Shell -o $(DOMAIN).pot $(GETTEXTFILES))

update-po: live-build.pot
	-for lang in $(LINGUAS); do\
	    msgmerge -U $$lang.po $(DOMAIN).pot; \
	done

install: $(MOFILES)
	-for lang in $(LINGUAS); do\
	    install -d $(DESTDIR)/usr/share/locale/$$lang/LC_MESSAGES/; \
	    install -m 644 $$lang.mo $(DESTDIR)/usr/share/locale/$$lang/LC_MESSAGES/$(DOMAIN).mo; \
	done

all: update-po $(MOFILES)

clean:
	rm -f *.mo *~

.PHONY: update-po
