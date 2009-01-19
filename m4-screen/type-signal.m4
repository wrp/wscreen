
dnl Check for signal handling characteristics.
dnl This code is obsolete, and ought to be replaced
dnl first by AC_TYPE_SIGNAL, and then completely
dnl removed when the code is upgraded to use
dnl sigaction
AC_DEFUN([screen_TYPE_SIGNAL],
[

if test -n "$posix" ; then

dnl POSIX has reliable signals with void return type.
AC_MSG_NOTICE([assuming posix signal definition])
AC_DEFINE([SIGVOID],[1],[signal handlers return void])

else

AC_CHECKING(return type of signal handlers)
AC_TRY_COMPILE(
[#include <sys/types.h>
#include <signal.h>
#ifdef signal
#undef signal
#endif
extern void (*signal ()) ();], [int i;],
AC_DEFINE([SIGVOID],[1],[signal handlers return void]))

AC_CHECKING(sigset)
AC_TRY_LINK([
#include <sys/types.h>
#include <signal.h>
],[
#ifdef SIGVOID
sigset(0, (void (*)())0);
#else
sigset(0, (int (*)())0);
#endif
], AC_DEFINE([USESIGSET],[1],
	[sigset for BSD 4.1 reliable signals is available.]))

AC_CHECKING(signal implementation)
AC_TRY_RUN([
#include <sys/types.h>
#include <signal.h>

#ifndef SIGCLD
#define SIGCLD SIGCHLD
#endif
#ifdef USESIGSET
#define signal sigset
#endif

int got;

#ifdef SIGVOID
void
#endif
hand()
{
  got++;
}

main()
{
  /* on hpux we use sigvec to get bsd signals */
#ifdef __hpux
  (void)signal(SIGCLD, hand);
  kill(getpid(), SIGCLD);
  kill(getpid(), SIGCLD);
  if (got < 2)
    exit(1);
#endif
  exit(0);
}
],[],AC_DEFINE([SYSVSIGS],[1],
	[signal handlers must be reinstalled after they have been called.]))

fi
])
