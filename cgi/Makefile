# Makefile

install:
	install -D -m 0755 cgi $(DESTDIR)/usr/lib/cgi-bin/live-build
	install -D -m 0755 cron $(DESTDIR)/etc/cron.d/live-build.cgi
	install -D -m 0644 default $(DESTDIR)/etc/default/live-build.cgi
	install -D -m 0644 logrotate $(DESTDIR)/etc/logrotate.d/live-build.cgi

	install -d -m 0755 $(DESTDIR)/var/log
	touch $(DESTDIR)/var/log/live
	chown www-data:www-data $(DESTDIR)/var/log/live

uninstall:
	rm -f $(DESTDIR)/usr/lib/cgi-bin/live-build
	rm -f $(DESTDIR)/etc/cron.d/live-build.cgi
	rm -f $(DESTDIR)/etc/default/live-build.cgi
	rm -f $(DESTDIR)/etc/logrotate.d/live-build.cgi

reinstall: uninstall install
