
dnl screen_PARSE_REV
dnl This macro is used to parse the revision information
dnl into a from usable by the current code base.  The code
dnl should change to use PACKAGE_VERSION instead, and this
dnl macro should be deleted when that happens.
AC_DEFUN([screen_PARSE_REV],
[
	# Parse revision number for backwards compatibility.
	# The code should be updated to use PACKAGE_VERSION
	# directly.
	AC_DEFINE([ORIGIN],["FAU"],[origin])
	REV=`echo $PACKAGE_VERSION |  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/'`
	AC_DEFINE_UNQUOTED([REV], [$REV], [Revision])
	VERS=`echo $PACKAGE_VERSION |  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/'`
	AC_DEFINE_UNQUOTED([VERS], [$VERS], [Version])
	PATCHLEVEL=`echo $PACKAGE_VERSION |  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/'`
	AC_DEFINE_UNQUOTED([PATCHLEVEL], [$PATCHLEVEL], [Patchlevel])
	AC_DEFINE([DATE], ["2-May-06"], [date])
	AC_DEFINE([STATE], ["devel"], [state])


	echo "#include <config.h>" > $srcdir/src/patchlevel.h
])
