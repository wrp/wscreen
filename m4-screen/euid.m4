
AC_DEFUN([screen_SETUID],[dnl
dnl If the system does not have setre{s,}uid, screen will use a forked process to
dnl safely create output files without retaining any special privileges.
AC_CHECK_FUNCS([setresuid setreuid seteuid setegid])

dnl seteuid() check:
dnl   linux seteuid was broken before V1.1.11
dnl   NeXT, AUX, ISC, and ultrix are still broken (no saved uid support)
dnl   Solaris seteuid doesn't change the saved uid, bad for
dnl     multiuser screen sessions

dnl master branch has the following template about seteuid:
dnl "If your system supports BSD4.4's seteuid() and setegid(), define
dnl HAVE_SETEUID."
dnl However, there is no configure check for setegid, so this
dnl remark cannot be trusted.  The original source contains
dnl system checks which assume a broken seteuid as described
dnl in the comment above.  We reluctantly maintain these
dnl checks for backwards compatibility.

AC_PREPROC_IFELSE( dnl
	[AC_LANG_PROGRAM([[
#if defined(linux) || defined(NeXT) || defined(_AUX_SOURCE) || defined(AUX) || defined(ultrix) || (defined(sun) && defined(SVR4)) || defined(ISC) || defined(sony_news)
#error
#endif]])], [],
	[AC_DEFINE([HAVE_SETEUID],[0])] dnl
	[AC_MSG_NOTICE([Assuming a broken seteuid based on system type])] dnl
) dnl
])
