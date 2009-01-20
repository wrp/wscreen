
AC_DEFUN([screen_UTMP],
[
dnl
dnl    ****  utmp handling  ****
dnl
m4_pushdef([ut_test_header],[
#include <time.h> /* to get time_t on SCO */
#include <sys/types.h>
#if defined(SVR4) && !defined(DGUX)
#include <utmpx.h>
#define utmp utmpx
#else
#include <utmp.h>
#endif
#ifdef __hpux
#define pututline _pututline
#endif
])
m4_pushdef([getutent_test_program],
	[int x = DEAD_PROCESS; pututline((struct utmp *)0); getutent();])
AC_CHECKING(getutent)
AC_TRY_LINK(ut_test_header, getutent_test_program,
	AC_DEFINE([GETUTENT],[1],[If your system has getutent(), pututline(),
		 etc. to write to the utmp file, define GETUTENT.]),
	olibs="$LIBS"
	LIBS="$LIBS -lgen"
	AC_CHECKING(getutent with -lgen)
	AC_TRY_LINK(ut_test_header, getutent_test_program,
		AC_DEFINE([GETUTENT],[1],[GETUTENT]), LIBS="$olibs")
) dnl
m4_popdef([getutent_test_program])

AC_CHECKING(ut_host)
AC_TRY_COMPILE( ut_test_header,
[struct utmp u; u.ut_host[0] = 0;], AC_DEFINE([UTHOST],[1],[
	Define UTHOST if the utmp file has a host field.]))
AC_CHECK_LIB([utempter],[addToUtmp])
m4_popdef([ut_test_header])
])
