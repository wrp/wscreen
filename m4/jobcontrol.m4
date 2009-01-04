
dnl
dnl   ****     Job control     ****
dnl
AC_DEFUN([screen_JOBCONTROL],
[

AC_CHECKING([BSD job control])
AC_TRY_LINK(
[#include <sys/types.h>
#include <sys/ioctl.h>
], [
#ifdef POSIX
tcsetpgrp(0, 0);
#else
int x = TIOCSPGRP;
#ifdef SYSV
setpgrp();
#else
int y = TIOCNOTTY;
#endif
#endif
],

AC_MSG_NOTICE([- you have jobcontrol])
AC_DEFINE([BSDJOBS],[1],[BSDJOBS]),

AC_MSG_NOTICE([- you don't have jobcontrol]))
])
