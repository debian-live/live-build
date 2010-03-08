# Makefile

install:
	install -D -m 0755 cgi $(DESTDIR)/usr/lib/cgi-bin/live-helper
	install -D -m 0755 cron $(DESTDIR)/etc/cron.d/live-helper.cgi
	install -D -m 0644 default $(DESTDIR)/etc/default/live-helper.cgi
	install -D -m 0644 logrotate $(DESTDIR)/etc/logrotate.d/live-helper.cgi

	install -d -m 0755 $(DESTDIR)/var/log
	touch $(DESTDIR)/var/log/live
	chown www-data:www-data $(DESTDIR)/var/log/live
