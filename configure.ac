#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.


AC_PREREQ([2.63.251])
AC_INIT([screen],
	m4_esyscmd([./git-version-gen .tarball-version]),
	[screen-devel@gnu.org])
AC_CONFIG_SRCDIR([src/screen.c])
AC_CONFIG_HEADERS([config.h])
AC_MSG_NOTICE([this is screen version $PACKAGE_VERSION])
AM_INIT_AUTOMAKE([gnu])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_CC
AC_PROG_CPP
AC_PROG_AWK
gl_EARLY

# Checks for libraries.
gl_INIT
AC_SEARCH_LIBS([strerror], [cposix])
AC_SEARCH_LIBS([sprintf], [util utils])

# Checks for header files.
AC_CHECK_HEADERS([syslog.h sys/types.h])
AC_CHECK_HEADERS([stropts.h string.h strings.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_UID_T

# Checks for library functions.
AC_SEARCH_LIBS([syslog],[bsd],[],[AC_DEFINE([NOSYSLOG],[1],[
 Define NOSYSLOG if you do not have logging facilities. Currently
 syslog() will be used to trace ``su'' commands only.])])

screen_USER_CONFIG

AS_IF([test -n "$ISC"],
  [AC_DEFINE([ISC],[1],[ISC])]
  [AC_HAVE_LIBRARY([inet],,AC_MSG_ERROR([libinet is required on $ISC]))]
)


AC_CANONICAL_HOST

AS_CASE([$host_cpu],
    [mips],      [AC_DEFINE([MIPS],[1],[MIPS])],
    [m68k],      [AC_DEFINE([sysV68],[1],[define if running on motorola 68000 family])],
    [pyramid],
        [AC_SEARCH_LIBS([open_controlling_pty],[pyr],[AC_DEFINE([OSX],[1],[OSX])])]
)
AS_CASE([$host_os],
    [riscos],
        [AC_DEFINE([USE_WAIT2],[1],[USE_WAIT2])]
        [AC_CHECK_LIB([bsd], [main])]
        [CPPFLAGS="$CPPFLAGS -I/usr/include/bsd"],
    [ultrix], [ULTRIX=1],
    [solaris*],
        [AC_CHECK_LIB([socket], [main])]
        [AC_CHECK_LIB([nsl], [main])]
        [AC_CHECK_LIB([kstat], [main])],
    []
)

AS_CASE([$host_vendor],
    [sequent],
        [AC_CHECK_LIB([seq], [main])]
        [AC_CHECK_LIB([sec], [main])]
        [AC_CHECK_LIB([nsl], [main])]
        [AC_CHECK_LIB([inet], [main])]
        [AC_CHECK_LIB([socket], [main])]
        [AC_CHECK_LIB([c], [main])]
        [AC_CHECK_LIB([termcap], [main])]
)


dnl ghazi@caip.rutgers.edu (Kaveh R. Ghazi):
dnl BBN butterfly is not POSIX, but a MACH BSD system.
dnl Do not define POSIX and TERMIO.
AC_CHECKING(for butterfly)
AC_EGREP_CPP(yes,
[#if defined(butterfly)
  yes;
#endif
],
    [butterfly=1],

    dnl This is not "butterfly".
    [AC_CHECKING([for POSIX.1])]
    [AC_EGREP_CPP([yes],[
#include <sys/types.h>
#include <unistd.h>
#ifdef _POSIX_VERSION
  yes;
#endif
],
        [AC_MSG_NOTICE([- you have a POSIX system])]
        [AC_DEFINE([POSIX],[1], dnl
            [Define POSIX if your system supports IEEE Std 1003.1-1988 (POSIX).]
        )]

        [posix=1]
    )]
)

AC_CHECKING(for System V)
AC_TRY_COMPILE([
#include <sys/types.h>
#include <signal.h>
#include <fcntl.h>],
	[int x = SIGCHLD | FNDELAY;],[],
	AC_DEFINE([SYSV],[1],[SYSV compliant (Sys V, HPUX, A/UX)])
)

screen_BUGGYLOGIN
screen_JOBCONTROL
AC_CHECK_FUNCS([setresuid setreuid])

dnl seteuid() check:
dnl   linux seteuid was broken before V1.1.11
dnl   NeXT, AUX, ISC, and ultrix are still broken (no saved uid support)
dnl   Solaris seteuid doesn't change the saved uid, bad for
dnl     multiuser screen sessions
AC_CHECKING(seteuid)
AC_TRY_LINK(,[
#if defined(linux) || defined(NeXT) || defined(_AUX_SOURCE) || defined(AUX) || defined(ultrix) || (defined(sun) && defined(SVR4)) || defined(ISC) || defined(sony_news)
seteuid_is_broken(0);
#else
seteuid(0);
#endif
], AC_DEFINE([HAVE_SETEUID],[1],[HAVE_SETEUID]))

AC_SEARCH_LIBS([select],[net nsl],[],[AC_MSG_ERROR(!!! no select - no screen)])
screen_SOCKET
AS_IF([test -n "$sock"],
	screen_SOCKET_ON_FS,
	screen_FIFO
)


AC_SEARCH_LIBS([tgetent],[curses termcap termlib ncursesw ncurses],
	[], AC_MSG_ERROR([!!! no tgetent - no screen]))

AC_TRY_RUN([
	main() { exit( strcmp( tgoto( "%p1%d", 0, 1 ), "1" ) ? 0 : 1); }],
	[AC_MSG_NOTICE([using the termcap database])],
	[AC_MSG_NOTICE([using the terminfo database])]
	[AC_DEFINE([TERMINFO],[1],[Define TERMINFO if the host machine
		 emulates the termcap routines with the terminfo database.
		 Thus the .screenrc file is parsed for the command 'terminfo'
		 instead of 'termcap'.])]
)

AC_CHECKING([ospeed])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[ extern short ospeed;]], [[ospeed = 5;]])],
	[],
	[AC_DEFINE([NEED_OSPEED],[1],[define if ospeed not available])]
)

dnl
dnl    ****  PTY specific things  ****
dnl
AC_CHECK_FILE([/dev/ptc],
	AC_DEFINE([HAVE_DEV_PTC],[1],[/dev/ptc character special device exists.])
)

AC_CHECK_FUNCS(getpt)

AC_CHECK_FILE([/dev/ptmx],
	AC_LINK_IFELSE(
		[AC_LANG_PROGRAM([],[[ptsname(0);grantpt(0);unlockpt(0);]])],
		[AC_DEFINE([HAVE_SVR4_PTYS],[1],[define if you have a
		 /dev/ptmx character special device and support the ptsname(),
		 grantpt(), unlockpt() functions.])],

		dnl check for openpty() if /dev/ptmx not available
		AC_SEARCH_LIBS([openpty],[util],
			[AC_DEFINE([HAVE_OPENPTY],[1],[HAVE_OPENPTY])]
		) dnl
	) dnl
) dnl

AC_CHECKING(for ptyranges)
AS_IF([test -d /dev/ptym],
	[pdir='/dev/ptym'],
	[pdir='/dev'])
dnl SCO uses ptyp%d
AC_EGREP_CPP(yes,
[#ifdef M_UNIX
   yes;
#endif
], ptys=`echo /dev/ptyp??`, ptys=`echo $pdir/pty??`)
AS_IF([test "$ptys" != "$pdir/pty??"],
p0=`echo $ptys | tr ' ' '\012' | sed -e 's/^.*\(.\).$/\1/g' | sort -u | tr -d '\012'`
p1=`echo $ptys | tr ' ' '\012' | sed -e 's/^.*\(.\)$/\1/g'  | sort -u | tr -d '\012'`
AC_DEFINE_UNQUOTED(PTYRANGE0,"$p0",[define PTYRANGE0 and or PTYRANGE1 if you
	want to adapt screen to unusual environments. E.g. For SunOs the
	defaults are "qpr" and "0123456789abcdef".])
AC_DEFINE_UNQUOTED(PTYRANGE1,"$p1",[see documentation for PTYRANGE0])
)

dnl    ****  pty mode/group handling ****
dnl
dnl support provided by Luke Mewburn <lm@rmit.edu.au>, 931222
AC_PATH_PROG([WRITEPATH], [write])
AC_PATH_PROG([XTERMPATH], [xterm])
AC_MSG_CHECKING([default tty permissions/group])
rm -f conftest_grp
AC_TRY_RUN([
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
main()
{
  struct stat sb;
  char *x,*ttyname();
  int om, m;
  FILE *fp;

  if (!(x = ttyname(0))) exit(1);
  if (stat(x, &sb)) exit(1);
  om = sb.st_mode;
  if (om & 002) exit(0);
  m = system("mesg y");
  if (m == -1 || m == 127) exit(1);
  if (stat(x, &sb)) exit(1);
  m = sb.st_mode;
  if (chmod(x, om)) exit(1);
  if (m & 002) exit(0);
  if (sb.st_gid == getgid()) exit(1);
  if (!(fp=fopen("conftest_grp", "w")))
    exit(1);
  fprintf(fp, "%d\n", sb.st_gid);
  fclose(fp);
  exit(0);
}
],[
    if test -f conftest_grp; then
	ptygrp=`cat conftest_grp`
    fi
],[
    found=
    if test -n "$WRITEPATH$XTERMPATH"; then
      findfollow=
      lsfollow=
      found=`find $WRITEPATH $XTERMPATH -follow -print 2>/dev/null`
      if test -n "$found"; then
	findfollow=-follow
	lsfollow=L
      fi
      if test -n "$XTERMPATH"; then
	ptygrpn=`ls -l$lsfollow $XTERMPATH | sed -n -e 1p | $AWK '{print $4}'`
	if test tty != "$ptygrpn"; then
	  XTERMPATH=
	fi
      fi
    fi
    if test -n "$WRITEPATH$XTERMPATH"; then
      found=`find $WRITEPATH $XTERMPATH $findfollow -perm -2000 -print` 
      if test -n "$found"; then
	ptygrp=`ls -ln$lsfollow $found | sed -n -e 1p | $AWK '{print $4}'`
      fi
    fi
  ]
)
rm -f conftest_grp

screen_VARTYPE([ptymode],[0622],[int],[permissions for the PTY.
	  Defaults to 0622])
screen_VARTYPE([ptygroup],[${ptygrp-real_gid}],[gid_t],[A numerical group-id
	if you do not want the tty to be in "your" group. Note, screen is
	unable to change mode or group of the pty if it is not installed with
	sufficient privilege. (e.g. set-uid-root)],
	[AC_INCLUDES_DEFAULT],[int real_gid;])

AC_MSG_RESULT([pty mode: ${ptymode}, group: $ptygroup])

screen_UTMP
screen_TYPE_SIGNAL

dnl
dnl    ****  libraries  ****
dnl

AC_CHECK_LIB([crypt_d],[main])
AC_CHECK_LIB([crypt],[main])
AC_CHECK_LIB([sec],[main])
AC_CHECK_LIB([shadow],[main])
AC_CHECK_LIB([sun],[main])


AC_EGREP_CPP(yes,
[#ifdef M_UNIX
   yes;
#endif
], LIBS="$LIBS -lsocket -lcrypt_i")

dnl
dnl    ****  misc things  ****
dnl
AH_TEMPLATE([BSDWAIT],[
	Define BSDWAIT if your system defines a 'union wait' in <sys/wait.h>

	Only allow BSDWAIT i.e. wait3 on nonposix systems, since
	posix implies wait(3) and waitpid(3). vdlinden@fwi.uva.nl
])
AC_CHECKING([wait union])
AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([[
#include <sys/types.h>
#include <sys/wait.h>
#ifdef POSIX
#error
#endif
		]],[[
			union wait x;
			int y;
#ifdef WEXITSTATUS
			y = WEXITSTATUS(x);
#endif
		]]
	)],
	[AC_DEFINE([BSDWAIT],[1])]
)

AS_IF([test -z "$butterfly"],
	[AC_CHECKING([for termio or termios])]
	[AC_PREPROC_IFELSE([#include <termio.h>],
		[AC_DEFINE([TERMIO],[1],
			[Define TERMIO if you have struct termio instead of struct sgttyb.
			This is usually the case for SVID systems, where BSD uses sgttyb.
			POSIX systems should define this anyway, even though they use
			struct termios.])],
		[AS_IF([test -n "$posix"],
			[AC_TRY_CPP([#include <termios.h>],
				[AC_DEFINE([TERMIO],[1])]
			)]
		)]
	)]
)

AC_MSG_CHECKING([getspnam])
AC_TRY_LINK([#include <shadow.h>],
	[getspnam("x");],
	AC_DEFINE([SHADOWPW],[1],[
		If the passwords are stored in a shadow file and you want the
		builtin lock to work properly, define SHADOWPW])
	AC_MSG_RESULT([yes]),
	AC_MSG_RESULT([no])
)

AC_CHECKING(getttyent)
AC_TRY_LINK(,[getttyent();], AC_DEFINE([GETTTYENT],[1],[GETTTYENT]))

AC_CHECK_FUNCS([fdwalk])

AC_MSG_CHECKING([for memcpy/memmove/bcopy that handles overlapping arguments])
m4_pushdef([memory_test],[[
main() {
  char buf[[10]];
  strcpy(buf, "abcdefghi");
  bcopy(buf, buf + 2, 3);
  if (strncmp(buf, "ababcf", 6))
    exit(1);
  strcpy(buf, "abcdefghi");
  bcopy(buf + 2, buf, 3);
  if (strncmp(buf, "cdedef", 6))
    exit(1);
  exit(0); /* libc version works properly.  */
}]])

AC_RUN_IFELSE(memory_test,
	AC_DEFINE([USEBCOPY],[1],[define if bcopy works])
	AC_MSG_RESULT([bcopy]),
	[AC_RUN_IFELSE([#define bcopy(s,d,l) memmove(d,s,l)] memory_test,
		AC_DEFINE([USEMEMMOVE],[1],[define if memmove works])
		AC_MSG_RESULT([memmove]),
		[AC_RUN_IFELSE([#define bcopy(s,d,l) memcpy(d,s,l)] memory_test,
			AC_DEFINE([USEMEMCPY],[1],[define if memcpy works])
			AC_MSG_RESULT([memcpy]),
			AC_MSG_RESULT([none]) dnl
		)] dnl
	)] dnl
) dnl
m4_popdef([memory_test])

AC_SYS_LONG_FILE_NAMES
AC_EGREP_CPP([yes],[
#ifndef HAVE_LONG_FILE_NAMES
   yes;
#endif
], AC_DEFINE([NAME_MAX], [14], [filesystem restriction on filename lengths]))

AC_MSG_CHECKING(for vsprintf)
AC_TRY_LINK(,[vsprintf(0,0,0);], AC_MSG_RESULT(yes);AC_DEFINE([USEVARARGS],[1],[USEVARARGS]), AC_MSG_RESULT(no))

AC_HEADER_DIRENT

AC_MSG_CHECKING([for nl_langinfo(CODESET)])
AC_TRY_LINK([
#include <langinfo.h>
],[nl_langinfo(CODESET);],
	AC_MSG_RESULT(yes)
	AC_DEFINE([HAVE_NL_LANGINFO],[1],[
	define HAVE_NL_LANGINFO if your system has the nl_langinfo() call
	and <langinfo.h> defines CODESET.]),
	AC_MSG_RESULT(no)
)

AC_SEARCH_LIBS(gethostname, nsl)

AC_CHECK_FUNCS(rename fchmod fchown strerror lstat _exit utimes vsnprintf getcwd setlocale strftime)

AC_ARG_ENABLE(pam, [  --enable-pam            enable PAM support])
if test "$enable_pam" = "yes"; then
    AC_MSG_CHECKING(for PAM support)
    oldlibs="$LIBS"
    LIBS="$LIBS -lpam"
    AC_TRY_LINK([#include <security/pam_appl.h>], [
	pam_start(0, 0, 0, 0);
	pam_authenticate(0, 0);
	pam_end(0,0);
    ], AC_MSG_RESULT(yes);AC_DEFINE([USE_PAM],[1],[USE_PAM]),
       AC_MSG_RESULT(no);LIBS="$oldlibs")
fi

screen_BOOLFEATURE([use_locale], [use localized month/day names])
screen_BOOLFEATURE([colors256], [enable support for 256 colors])
screen_BOOLFEATURE([rxvt_osc], [enable support for rxvt OSC codes
       (change fgcolor/bgcolor/bgpicture sequences)])
screen_BOOLFEATURE([telnet],[enable builtin telnet
	(Syntax: screen //telnet host @<:@port@:>@)],[no],[builtin_telnet])

AC_TRY_RUN(main(){exit(0);},,AC_MSG_ERROR(Can't run the compiler - internal error. Sorry.))

AC_OUTPUT([Makefile src/Makefile src/doc/Makefile lib/Makefile])

