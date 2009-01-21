dnl Decide whether or not to define BUGGYGETLOGIN
dnl It is not clear exactly why this is written as it is,
dnl but I'm keeping it as is for backwards compatibility until
dnl its purpose is known.  Currently, it adds -lelf to LIBS
dnl if it and <utmpx.h> are available.  If either of those is
dnl missing and dwarf.h or elf.h are present, then SVR4 and
dnl BUGGYGELOGIN are defined.  If one of libelf or utmpx.h
dnl is unavailable and both dwarf.h and elf.h are unavailable,
dnl there is no effect.
AC_DEFUN([screen_BUGGYLOGIN],[dnl
	oldlibs="$LIBS"
	LIBS="$LIBS -lelf"
	AC_CHECKING([SVR4])
	AC_LINK_IFELSE([#include <utmpx.h>],
		[AC_CHECK_HEADER([dwarf.h],
			 AC_DEFINE([SVR4],[1],[SVR4]) dnl
			 AC_DEFINE([BUGGYGETLOGIN],[1],
	[If ttyslot() breaks getlogin() by returning indexes to utmp entries
	of type DEAD_PROCESS, then our getlogin() replacement should be
	selected by defining BUGGYGETLOGIN.]),
			[AC_CHECK_HEADER([elf.h],
				AC_DEFINE([SVR4],[1],[SVR4])dnl
				AC_DEFINE([BUGGYGETLOGIN],[1]))dnl
			]dnl
		)]dnl
	,[LIBS="$oldlibs"])
])
