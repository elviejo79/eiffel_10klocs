# Process this file with automake to produce Makefile.in

bin_PROGRAMS = eformmail.cgi

eformmail_cgi_SOURCES = form_mail.e key_configuration.e main_configuration.e

EXTRA_DIST = \
	system.xace build.eant


eformmail.cgi$(EXEEXT):
	geant compile_debug_$(GOBO_EIFFEL)


# clean

clean-generic:
	geant clean
