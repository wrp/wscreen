
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
])
