dnl Process this file with autoconf to produce a configure script
AC_INIT(eformmail, 2.0)
AC_CONFIG_AUX_DIR(config)
AM_INIT_AUTOMAKE


# Check for programs
# Strictly speaking, we don't need those, but automake wants to have them.
AC_PROG_INSTALL
AC_PROG_CC

# Check for Eiffel compiler
AC_PROG_GOBO

AC_CHECK_RQRD_CLUSTER(GOBO)
AC_CHECK_RQRD_XACE(EPOSIX, src)

#
# Automake
#
AC_OUTPUT( \
  Makefile \
  doc/Makefile \
  etc/Makefile \
  src/Makefile)