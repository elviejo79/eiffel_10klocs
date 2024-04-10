# Process this file with automake to produce Makefile.in

SUBDIRS = src doc etc

EXTRA_DIST = ChangeLog LICENSE


RELEASE_FILES = \
	README \
	INSTALL \
	NEWS \
	LICENSE \
	ChangeLog \
	bin/eformmail.cgi \
	doc/eformmail.html \
	doc/example_form.html \
	etc/main.conf \
	etc/key.conf


release:
	mkdir $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
	cp $(RELEASE_FILES) eformmail-$(PACKAGE_VERSION)
	tar cvzf $(PACKAGE_TARNAME)-`uname`-$(PACKAGE_VERSION).tar.gz $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
	rm -rf $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)