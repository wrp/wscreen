#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT([screen], [4.1.0], [screen-devel@gnu.org])
AC_CONFIG_SRCDIR([screen.c])
AC_CONFIG_HEADERS([config.h])
AC_MSG_NOTICE([this is screen version $PACKAGE_VERSION])

# After autoconf is cleaned up, we'll add automake support.
# AM_INIT_AUTOMAKE([foreign])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_CC
AC_PROG_CPP
AC_PROG_AWK

# Checks for libraries.
AC_SEARCH_LIBS([strerror], [cposix])
AC_SEARCH_LIBS([sprintf], [util utils])

# Checks for header files.
# Checks for typedefs, structures, and compiler characteristics.
# Checks for library functions.

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

# User configuration section.
AC_ARG_VAR([MAXWIN],[Maximum of simultaneously allowed windows per screen session.])
AC_DEFINE_UNQUOTED([MAXWIN],[${MAXWIN-40}],[Maximum of simultaneously allowed windows per screen session.])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[int x = MAXWIN;])],[],AC_MSG_ERROR([MAXWIN must be an int]))

AC_MSG_CHECKING([for the socket dir])
AC_ARG_VAR([SOCKDIR],
    [Where to put the per-user sockets.

        Define SOCKDIR to be the directory to contain the named sockets
        screen creates. This should be in a common subdirectory, such as
        /usr/local or /tmp. It makes things a little more secure if you
        choose a directory which is not writable by everyone or where the
        "sticky" bit is on, but this isn't required.
        If SOCKDIR is not defined screen will put the named sockets in
        the user's home directory. Notice that this can cause you problems
        if some user's HOME directories are AFS- or NFS-mounted. Especially
        AFS is unlikely to support named sockets.

        Screen will name the subdirectories "S-$USER" (e.g /tmp/S-davison).
    ]
)
AS_IF([test -z "${SOCKDIR}"],
    [SOCKDIR="(eff_uid ? \"/tmp/uscreens\" : \"/tmp/screens\")"]
)

dnl Validate SOCKDIR.  If SOCKDIR is invalid, try putting "" around it.
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[int eff_uid; char* s = ${SOCKDIR};])],[],
    [SOCKDIR=\"$SOCKDIR\"]
    [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[char* s = ${SOCKDIR};])],[],
        AC_MSG_ERROR([SOCKDIR:$SOCKDIR must evaluate to a valid char *])
    ])
)
AC_MSG_RESULT(${SOCKDIR})
AC_DEFINE_UNQUOTED([SOCKDIR], [$SOCKDIR], [The socket directory])

AC_MSG_CHECKING([if the socket dir is remote])
AC_ARG_WITH([remote-socket-dir],
    [AS_HELP_STRING([--with-remote-socket-dir],
        [This option indicates that the path specified in SOCKDIR
        is on a network mount.]
    )],
    [AS_CASE([${withval}],
        [yes], [REMOTE_SOCKDIR="${withval}"],
        [REMOTE_SOCKDIR=no]
    )],
    [REMOTE_SOCKDIR=no] dnl
)
AS_IF([test "X$REMOTE_SOCKDIR" = Xno ],
    [AC_DEFINE([SOCKDIR_IS_LOCAL_TO_HOST],[1],
        [Define this if the SOCKDIR is not shared between hosts.]
    )] dnl
)
AC_MSG_RESULT(${REMOTE_SOCKDIR})


dnl --- cut ---  Below here is old.

define([AC_NOTE],
[AC_MSG_NOTICE([$1])
])

AS_IF([test -n "$ISC"],
  [AC_DEFINE([ISC],[1],[ISC])]
  [AC_HAVE_LIBRARY([inet],,AC_MSG_ERROR([libinet is required on $ISC]))]
)

if test -f /sysV68 ; then
AC_DEFINE([sysV68],[1],[sysV68])
fi

AC_CANONICAL_HOST

AS_CASE([$host_cpu],
    [mips],      [AC_DEFINE([MIPS],[1],[MIPS])],
    [pyramid],
        [AC_CHECK_LIB([pyr], [main], [],
	    [AC_TRY_LINK( [],[open_controlling_pty("")], AC_DEFINE([OSX],[1],[OSX]), LIBS="$oldlibs")]
        )]
)
AS_CASE([$host_os],
    [riscos],
        [AC_DEFINE([USE_WAIT2],[1],[USE_WAIT2])]
	[LIBS="$LIBS -lbsd"]
	[CC="$CC -I/usr/include/bsd"],
    [ultrix], ULTRIX=1
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
AC_TRY_COMPILE(
[#include <sys/types.h>
#include <signal.h>
#include <fcntl.h>], [int x = SIGCHLD | FNDELAY;], , AC_DEFINE([SYSV],[1],[SYSV]))

AC_CHECKING(for sequent/ptx)
AC_EGREP_CPP(yes,
[#ifdef _SEQUENT_
  yes;
#endif
], LIBS="$LIBS -lsocket -linet";seqptx=1)

oldlibs="$LIBS"
LIBS="$LIBS -lelf"
AC_CHECKING(SVR4)
AC_TRY_LINK([#include <utmpx.h>
],,
[AC_CHECK_HEADER(dwarf.h, AC_DEFINE([SVR4],[1],[SVR4]) AC_DEFINE([BUGGYGETLOGIN],[1],[buggygetlogin]),
[AC_CHECK_HEADER(elf.h, AC_DEFINE([SVR4],[1],[SVR4]) AC_DEFINE([BUGGYGETLOGIN],[1],[buggygetlogin]))])]
,LIBS="$oldlibs")
AC_CHECK_HEADERS([stropts.h string.h strings.h])

AC_CHECKING(for Solaris 2.x)
AC_EGREP_CPP(yes,
[#if defined(SVR4) && defined(sun)
  yes
#endif
], LIBS="$LIBS -lsocket -lnsl -lkstat")

dnl
dnl    ****  typedefs ****
dnl
dnl (currently not used)
dnl
dnl AC_CHECKING(for pid_t)
dnl AC_EGREP_CPP(pid_t,[#include <sys/types.h>
dnl ],AC_DEFINE([PID_T_DEFINED],[1],[PID_T_DEFINED]))
dnl
dnl AC_CHECKING(for sig_t)
dnl AC_EGREP_CPP(sig_t,[#include <sys/types.h>
dnl #include <signal.h>
dnl ],AC_DEFINE([SIG_T_DEFINED],[1],[SIG_T_DEFINED]))
dnl
dnl AC_CHECKING(for uid_t)
dnl AC_EGREP_CPP(uid_t,[#include <sys/types.h>
dnl ],AC_DEFINE([UID_T_DEFINED],[1],[UID_T_DEFINED]))
dnl

dnl
dnl   ****     Job control     ****
dnl

AC_CHECKING(BSD job jontrol)
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
], AC_NOTE(- you have jobcontrol) AC_DEFINE([BSDJOBS],[1],[BSDJOBS]), AC_NOTE(- you don't have jobcontrol))

dnl
dnl    ****  setresuid(), setreuid(), seteuid()  ****
dnl
AC_CHECKING(setresuid)
AC_TRY_LINK(,[
setresuid(0, 0, 0);
], AC_DEFINE([HAVE_SETRESUID],[1],[HAVE_SETRESUID]))
AC_CHECKING(setreuid)
AC_TRY_LINK(,[
setreuid(0, 0);
], AC_DEFINE([HAVE_SETREUID],[1],[HAVE_SETREUID]))
dnl
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

dnl
dnl    ****  select()  ****
dnl

AC_CHECKING(select)
AC_TRY_LINK(,[select(0, 0, 0, 0, 0);],, 
LIBS="$LIBS -lnet -lnsl"
AC_CHECKING(select with $LIBS)
AC_TRY_LINK(,[select(0, 0, 0, 0, 0);],, 
AC_MSG_ERROR(!!! no select - no screen))
)
dnl
dnl    ****  FIFO tests  ****
dnl

AC_CHECKING(fifos)
AC_TRY_RUN([
/* For select - According to POSIX 1003.1-2001 */
#include <sys/select.h>

/* For select - According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>
#include <fcntl.h>

#ifndef O_NONBLOCK
#define O_NONBLOCK O_NDELAY
#endif
#ifndef S_IFIFO
#define S_IFIFO 0010000
#endif

char *fin = "/tmp/conftest$$";

main()
{
  struct stat stb;
  fd_set f;

  (void)alarm(5);
  unlink(fin);
#ifdef POSIX
  if (mkfifo(fin, 0777))
#else
  if (mknod(fin, S_IFIFO|0777, 0))
#endif
    exit(1);
  if (stat(fin, &stb) || (stb.st_mode & S_IFIFO) != S_IFIFO)
    exit(1);
  close(0);
#ifdef __386BSD__
  /*
   * The next test fails under 386BSD, but screen works using fifos.
   * Fifos in O_RDWR mode are only used for the BROKEN_PIPE case and for
   * the select() configuration test.
   */
  exit(0);
#endif
  if (open(fin, O_RDONLY | O_NONBLOCK))
    exit(1);
  if (fork() == 0)
    {
      close(0);
      if (open(fin, O_WRONLY | O_NONBLOCK))
	exit(1);
      close(0);
      if (open(fin, O_WRONLY | O_NONBLOCK))
	exit(1);
      if (write(0, "TEST", 4) == -1)
	exit(1);
      exit(0);
    }
  FD_SET(0, &f);
  if (select(1, &f, 0, 0, 0) == -1)
    exit(1);
  exit(0);
}
], AC_NOTE(- your fifos are usable) fifo=1,
AC_NOTE(- your fifos are not usable))
rm -f /tmp/conftest*

if test -n "$fifo"; then
AC_CHECKING(for broken fifo implementation)
AC_TRY_RUN([
/* For select - According to POSIX 1003.1-2001 */
#include <sys/select.h>

/* For select - According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>
#include <fcntl.h>

#ifndef O_NONBLOCK
#define O_NONBLOCK O_NDELAY
#endif
#ifndef S_IFIFO
#define S_IFIFO 0010000
#endif

char *fin = "/tmp/conftest$$";

main()
{
  struct timeval tv;
  fd_set f;

#ifdef POSIX
  if (mkfifo(fin, 0600))
#else
  if (mknod(fin, S_IFIFO|0600, 0))
#endif
    exit(1);
  close(0);
  if (open(fin, O_RDONLY|O_NONBLOCK))
    exit(1);
  FD_SET(0, &f);
  tv.tv_sec = 1;
  tv.tv_usec = 0;
  if (select(1, &f, 0, 0, &tv))
    exit(1);
  exit(0);
}
], AC_NOTE(- your implementation is ok), 
AC_NOTE(- you have a broken implementation) AC_DEFINE([BROKEN_PIPE],[1],[BROKEN_PIPE]) fifobr=1)
rm -f /tmp/conftest*
fi

dnl
dnl    ****  SOCKET tests  ****
dnl 
dnl 	may need  	LIBS="$LIBS -lsocket" 	here
dnl

AC_CHECKING(sockets)
AC_TRY_RUN([
/* For select - According to POSIX 1003.1-2001 */
#include <sys/select.h>

/* For select - According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/un.h>

char *son = "/tmp/conftest$$";

main()
{
  int s1, s2, l;
  struct sockaddr_un a;
  fd_set f;

  (void)alarm(5);
  if ((s1 = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
    exit(1);
  a.sun_family = AF_UNIX;
  strcpy(a.sun_path, son);
  (void) unlink(son);
  if (bind(s1, (struct sockaddr *) &a, strlen(son)+2) == -1)
    exit(1);
  if (listen(s1, 2))
    exit(1);
  if (fork() == 0)
    {
      if ((s2 = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
	kill(getppid(), 3);
      (void)connect(s2, (struct sockaddr *)&a, strlen(son) + 2);
      if (write(s2, "HELLO", 5) == -1)
	kill(getppid(), 3);
      exit(0);
    }
  l = sizeof(a);
  close(0);
  if (accept(s1, &a, &l))
    exit(1);
  FD_SET(0, &f);
  if (select(1, &f, 0, 0, 0) == -1)
    exit(1);
  exit(0);
}
], AC_NOTE(- your sockets are usable) sock=1,
AC_NOTE(- your sockets are not usable))
rm -f /tmp/conftest*

if test -n "$sock"; then
AC_CHECKING(socket implementation)
AC_TRY_RUN([
/* For select - According to POSIX 1003.1-2001 */
#include <sys/select.h>

/* For select - According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/un.h>

char *son = "/tmp/conftest$$";

main()
{
  int s;
  struct stat stb;
  struct sockaddr_un a;
  if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
    exit(0);
  a.sun_family = AF_UNIX;
  strcpy(a.sun_path, son);
  (void) unlink(son);
  if (bind(s, (struct sockaddr *) &a, strlen(son)+2) == -1)
    exit(0);
  if (stat(son, &stb))
    exit(1);
  close(s);
  exit(0);
}
],AC_NOTE(- you are normal),
AC_NOTE(- unix domain sockets are not kept in the filesystem)
AC_DEFINE([SOCK_NOT_IN_FS],[1],[SOCK_NOT_IN_FS]) socknofs=1)
rm -f /tmp/conftest*
fi


dnl
dnl    ****  choose sockets or fifos  ****
dnl
if test -n "$fifo"; then
  if test -n "$sock"; then
    if test -n "$nore"; then
      AC_NOTE(- hmmm... better take the fifos)
      AC_DEFINE([NAMEDPIPE],[1],[NAMEDPIPE])
    elif test -n "$fifobr"; then
      AC_NOTE(- as your fifos are broken lets use the sockets.)
    else
      AC_NOTE(- both sockets and fifos usable. let's take sockets.)
    fi
  else
    AC_NOTE(- using named pipes, of course)
    AC_DEFINE([NAMEDPIPE],[1],[NAMEDPIPE])
  fi
elif test -n "$sock"; then
  AC_NOTE(- using unix-domain sockets, of course)
else
  AC_MSG_ERROR(you have neither usable sockets nor usable pipes -> no screen)
fi

dnl
dnl    ****  check the select implementation ****
dnl

AC_CHECKING(select return value)
AC_TRY_RUN([
/* For select - According to POSIX 1003.1-2001 */
#include <sys/select.h>

/* For select - According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>
#include <fcntl.h>

char *nam = "/tmp/conftest$$";

#ifdef NAMEDPIPE

#ifndef O_NONBLOCK
#define O_NONBLOCK O_NDELAY
#endif
#ifndef S_IFIFO
#define S_IFIFO 0010000
#endif


main()
{
  fd_set f;

#ifdef __FreeBSD__
/* From Andrew A. Chernov (ache@astral.msk.su):
 * opening RDWR fifo fails in BSD 4.4, but select return values are
 * right.
 */
  exit(0);
#endif
  (void)alarm(5);
#ifdef POSIX
  if (mkfifo(nam, 0777))
#else
  if (mknod(nam, S_IFIFO|0777, 0))
#endif
    exit(1);
  close(0);
  if (open(nam, O_RDWR | O_NONBLOCK))
    exit(1);
  if (write(0, "TEST", 4) == -1)
    exit(1);

#else

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

main()
{
  int s1, s2, l;
  struct sockaddr_un a;
  fd_set f;

  (void)alarm(5);
  if ((s1 = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
    exit(1);
  a.sun_family = AF_UNIX;
  strcpy(a.sun_path, nam);
  (void) unlink(nam);
  if (bind(s1, (struct sockaddr *) &a, strlen(nam)+2) == -1)
    exit(1);
  if (listen(s1, 2))
    exit(1);
  if (fork() == 0)
    {
      if ((s2 = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
	kill(getppid(), 3);
      (void)connect(s2, (struct sockaddr *)&a, strlen(nam) + 2);
      if (write(s2, "HELLO", 5) == -1)
	kill(getppid(), 3);
      exit(0);
    }
  l = sizeof(a);
  close(0);
  if (accept(s1, (struct sockaddr *)&a, &l))
    exit(1);
#endif


  FD_SET(0, &f);
  if (select(1, &f, 0, 0, 0) == -1)
    exit(1);
  if (select(1, &f, &f, 0, 0) != 2)
    exit(1);
  exit(0);
}
],AC_NOTE(- select is ok),
AC_NOTE(- select can't count) AC_DEFINE([SELECT_BROKEN],[1],[SELECT_BROKEN]))

dnl
dnl    ****  termcap or terminfo  ****
dnl
AC_CHECKING(for tgetent)
AC_TRY_LINK(,tgetent((char *)0, (char *)0);,,
olibs="$LIBS"
LIBS="-lcurses $olibs"
AC_CHECKING(libcurses)
AC_TRY_LINK(,[
#ifdef __hpux
__sorry_hpux_libcurses_is_totally_broken_in_10_10();
#else
tgetent((char *)0, (char *)0);
#endif
],,
LIBS="-ltermcap $olibs"
AC_CHECKING(libtermcap)
AC_TRY_LINK(,tgetent((char *)0, (char *)0);,,
LIBS="-ltermlib $olibs"
AC_CHECKING(libtermlib)
AC_TRY_LINK(,tgetent((char *)0, (char *)0);,,
LIBS="-lncursesw $olibs"
AC_CHECKING(libncursesw)
AC_TRY_LINK(,tgetent((char *)0, (char *)0);,,
LIBS="-lncurses $olibs"
AC_CHECKING(libncurses)
AC_TRY_LINK(,tgetent((char *)0, (char *)0);,,
AC_MSG_ERROR(!!! no tgetent - no screen)))))))

AC_TRY_RUN([
main()
{
 exit(strcmp(tgoto("%p1%d", 0, 1), "1") ? 0 : 1);
}], AC_NOTE(- you use the termcap database),
AC_NOTE(- you use the terminfo database) AC_DEFINE([TERMINFO],[1],[TERMINFO]))
AC_CHECKING(ospeed)
AC_TRY_LINK(extern short ospeed;,ospeed=5;,,AC_DEFINE([NEED_OSPEED],[1],[NEED_OSPEED]))

dnl
dnl    ****  PTY specific things  ****
dnl
AC_CHECKING(for /dev/ptc)
if test -r /dev/ptc; then
AC_DEFINE([HAVE_DEV_PTC],[1],[HAVE_DEV_PTC])
fi

AC_CHECKING(for SVR4 ptys)
sysvr4ptys=
if test -c /dev/ptmx ; then
AC_TRY_LINK([],[ptsname(0);grantpt(0);unlockpt(0);],[AC_DEFINE([HAVE_SVR4_PTYS],[1],[HAVE_SVR4_PTYS])
sysvr4ptys=1])
fi

AC_CHECK_FUNCS(getpt)

dnl check for openpty()
if test -z "$sysvr4ptys"; then
AC_CHECK_FUNCS(openpty,,
[AC_CHECK_LIB(util,openpty, [AC_DEFINE([HAVE_OPENPTY],[1],[HAVE_OPENPTY])] [LIBS="$LIBS -lutil"])])
fi

AC_CHECKING(for ptyranges)
if test -d /dev/ptym ; then
pdir='/dev/ptym'
else
pdir='/dev'
fi
dnl SCO uses ptyp%d
AC_EGREP_CPP(yes,
[#ifdef M_UNIX
   yes;
#endif
], ptys=`echo /dev/ptyp??`, ptys=`echo $pdir/pty??`)
dnl if test -c /dev/ptyp19; then
dnl ptys=`echo /dev/ptyp??`
dnl else
dnl ptys=`echo $pdir/pty??`
dnl fi
if test "$ptys" != "$pdir/pty??" ; then
p0=`echo $ptys | tr ' ' '\012' | sed -e 's/^.*\(.\).$/\1/g' | sort -u | tr -d '\012'`
p1=`echo $ptys | tr ' ' '\012' | sed -e 's/^.*\(.\)$/\1/g'  | sort -u | tr -d '\012'`
AC_DEFINE_UNQUOTED(PTYRANGE0,"$p0",[undocumented])
AC_DEFINE_UNQUOTED(PTYRANGE1,"$p1",[undocumented])
fi

dnl    ****  pty mode/group handling ****
dnl
dnl support provided by Luke Mewburn <lm@rmit.edu.au>, 931222
AC_ARG_WITH(pty-mode, [  --with-pty-mode=mode    default mode for ptys], [ ptymode="${withval}" ])
AC_ARG_WITH(pty-group, [  --with-pty-group=group  default group for ptys], [ ptygrp="${withval}" ])
test -n "$ptymode" || ptymode=0620
if test -n "$ptygrp" ; then
AC_DEFINE_UNQUOTED(PTYMODE, $ptymode,[undocumented])
AC_DEFINE_UNQUOTED(PTYGROUP,$ptygrp,[undocumented])
else

AC_CHECKING(default tty permissions/group)
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
	AC_NOTE([- pty mode: $ptymode, group: $ptygrp])
	AC_DEFINE_UNQUOTED(PTYMODE, $ptymode,[undocumented])
	AC_DEFINE_UNQUOTED(PTYGROUP,$ptygrp,[undocumented])
    else
	AC_NOTE(- ptys are world accessable)
    fi
],[
    WRITEPATH=''
    XTERMPATH=''
    AC_PATH_PROG(WRITEPATH, write)
    AC_PATH_PROG(XTERMPATH, xterm)
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
	AC_NOTE([- pty mode: $ptymode, group: $ptygrp])
	AC_DEFINE_UNQUOTED(PTYMODE, $ptymode,[undocumented])
	AC_DEFINE_UNQUOTED(PTYGROUP,$ptygrp,[undocumented])
      else
	AC_NOTE(- ptys are world accessable)
      fi
    else
      AC_NOTE(- can't determine - assume ptys are world accessable)
    fi
  ]
)
rm -f conftest_grp
fi

dnl
dnl    ****  utmp handling  ****
dnl
AC_CHECKING(getutent)
AC_TRY_LINK([
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
],
[int x = DEAD_PROCESS; pututline((struct utmp *)0); getutent();], AC_DEFINE([GETUTENT],[1],[GETUTENT]),
olibs="$LIBS"
LIBS="$LIBS -lgen"
AC_CHECKING(getutent with -lgen)
AC_TRY_LINK([
#include <time.h>
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
],
[int x = DEAD_PROCESS; pututline((struct utmp *)0); getutent();], AC_DEFINE([GETUTENT],[1],[GETUTENT]), LIBS="$olibs")
)
AC_CHECKING(ut_host)
AC_TRY_COMPILE([
#include <time.h>
#include <sys/types.h>
#if defined(SVR4) && !defined(DGUX)
#include <utmpx.h>
#define utmp utmpx
#else
#include <utmp.h>
#endif
],[struct utmp u; u.ut_host[0] = 0;], AC_DEFINE([UTHOST],[1],[UTHOST]))
AC_CHECK_HEADER(utempter.h, have_utempter=yes, have_utempter=no)
if test "$have_utempter" = yes; then
  AC_DEFINE([HAVE_UTEMPTER],[1],[HAVE_UTEMPTER])
  LIBS="$LIBS -lutempter"
fi


AC_CHECKING(getloadavg)
AC_TRY_LINK(,[getloadavg((double *)0, 0);],
AC_DEFINE([LOADAV_GETLOADAVG],[1],[LOADAV_GETLOADAVG]) load=1,
if test -f /usr/lib/libkvm.a ; then
olibs="$LIBS"
LIBS="$LIBS -lkvm"
AC_CHECKING(getloadavg with -lkvm)
AC_TRY_LINK(,[getloadavg((double *)0, 0);],
AC_DEFINE([LOADAV_GETLOADAVG],[1],[LOADAV_GETLOADAVG]) load=1, LIBS="$olibs")
fi
)

if test -z "$load" ; then
AC_EGREP_CPP(yes,
[#if defined(NeXT) || defined(apollo) || defined(linux)
  yes;
#endif
], load=1)
fi
if test -z "$load" ; then
AC_CHECKING(for kernelfile)
for core in /unix /vmunix /dynix /hp-ux /xelos /dev/ksyms /kernel/unix /kernel/genunix /unicos /mach /netbsd /386bsd /dgux /bsd /stand/vmunix; do
  if test -f $core || test -c $core; then
    break
  fi
done
if test ! -f $core && test ! -c $core ; then
  AC_NOTE(- no kernelfile found)
else
  AC_NOTE(- using kernelfile '$core')
  if test -r $core ; then
  AC_DEFINE_UNQUOTED(LOADAV_UNIX,"$core",[undocumented])
  AC_CHECK_HEADER(nlist.h,
    [AC_DEFINE([NLIST_STRUCT],[1],[NLIST_STRUCT])
     AC_CHECKING(n_un in struct nlist)
     AC_TRY_COMPILE([#include <nlist.h>],
       [struct nlist n; n.n_un.n_name = 0;],
        AC_DEFINE([NLIST_NAME_UNION],[1],[NLIST_NAME_UNION]))])

  AC_CHECKING(for nlist declaration)
  AC_EGREP_CPP([nlist(( |	)( |	)*.*\(|\()],[
#ifdef NLIST_STRUCT
# include <nlist.h>
#else
# include <a.out.h>
#endif
],AC_DEFINE([NLIST_DECLARED],[1],[NLIST_DECLARED]))

  AC_CHECKING(for avenrun symbol)
  nlist64=
  for av in avenrun _avenrun _Loadavg avenrun _avenrun _Loadavg; do
  AC_TRY_RUN([
#include <sys/types.h>
#ifdef NLIST_STRUCT
#include <nlist.h>
#else
#include <a.out.h>
#endif

$nlist64

struct nlist nl[2];

main()
{
#if !defined(_AUX_SOURCE) && !defined(AUX)
# ifdef NLIST_NAME_UNION
  nl[0].n_un.n_name = "$av";
# else
  nl[0].n_name = "$av";
# endif
#else
  strncpy(nl[0].n_name, "$av", sizeof(nl[0].n_name));
#endif
  nlist(LOADAV_UNIX, nl);
  if (nl[0].n_value == 0)
    exit(1);
  exit(0);
}
  ],avensym=$av;break)
  if test "$av" = _Loadavg; then
    nlist64='#define nlist nlist64'
  fi
  done
  if test -z "$avensym" ; then
    AC_NOTE(- no avenrun symbol found)
  else
    AC_NOTE(- using avenrun symbol '$avensym')
    AC_DEFINE_UNQUOTED(LOADAV_AVENRUN,"$avensym",[undocumented])
    if test -n "$nlist64"; then
      AC_NOTE(- used nlist64 to find it)
      AC_DEFINE([LOADAV_USE_NLIST64],[1],[LOADAV_USE_NLIST64])
    fi
    load=1
  fi
  else
    AC_NOTE(  Can't configure the load average display feature)
    AC_NOTE(  because $core is not readable by you.)
    AC_NOTE(  To configure the load average display feature,)
    AC_NOTE(  re-run configure as root if possible.)
    AC_NOTE(  If you are not the system administrator then disregard)
    AC_NOTE(  this warning.  You can still use screen without)
    AC_NOTE(  the load average display feature.)
  fi
fi
fi



dnl
dnl    ****  signal handling  ****
dnl
if test -n "$posix" ; then

dnl POSIX has reliable signals with void return type.
AC_NOTE(assuming posix signal definition)
AC_DEFINE([SIGVOID],[1],[SIGVOID])

else

AC_CHECKING(return type of signal handlers)
AC_TRY_COMPILE(
[#include <sys/types.h>
#include <signal.h>
#ifdef signal
#undef signal
#endif
extern void (*signal ()) ();], [int i;], AC_DEFINE([SIGVOID],[1],[SIGVOID]))
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
], AC_DEFINE([USESIGSET],[1],[USESIGSET]))
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
],,AC_DEFINE([SYSVSIGS],[1],[SYSVSIGS]))

fi

dnl
dnl    ****  libraries  ****
dnl

AC_CHECKING(for crypt and sec libraries)
test -f /lib/libcrypt_d.a || test -f /usr/lib/libcrypt_d.a && LIBS="$LIBS -lcrypt_d"
oldlibs="$LIBS"
LIBS="$LIBS -lcrypt"
AC_CHECKING(crypt)
AC_TRY_LINK(,,,LIBS="$oldlibs")
test -f /lib/libsec.a || test -f /usr/lib/libsec.a && LIBS="$LIBS -lsec"
test -f /lib/libshadow.a || test -f /usr/lib/libshadow.a && LIBS="$LIBS -lshadow"
oldlibs="$LIBS"
LIBS="$LIBS -lsun"
AC_CHECKING(IRIX sun library)
AC_TRY_LINK(,,,LIBS="$oldlibs")

AC_CHECKING(syslog)
AC_TRY_LINK(,[closelog();], , [oldlibs="$LIBS"
LIBS="$LIBS -lbsd"
AC_CHECKING(syslog in libbsd.a)
AC_TRY_LINK(, [closelog();], AC_NOTE(- found.), [LIBS="$oldlibs"
AC_NOTE(- bad news: syslog missing.) AC_DEFINE([NOSYSLOG],[1],[NOSYSLOG])])])

AC_EGREP_CPP(yes,
[#ifdef M_UNIX
   yes;
#endif
], LIBS="$LIBS -lsocket -lcrypt_i")

dnl
dnl    ****  misc things  ****
dnl
AC_CHECKING(wait union)
AC_TRY_COMPILE([#include <sys/types.h>
#include <sys/wait.h>
],[
  union wait x;
  int y;
#ifdef WEXITSTATUS
  y = WEXITSTATUS(x);
#endif
],AC_DEFINE([BSDWAIT],[1],[BSDWAIT]))

m4_pushdef([TERMIO_DESCRIPTION],[[
Define TERMIO if you have struct termio instead of struct sgttyb.
This is usually the case for SVID systems, where BSD uses sgttyb.
POSIX systems should define this anyway, even though they use
struct termios.]])

AS_IF([test -z "$butterfly"],
    [AC_CHECKING([for termio or termios])]
    [AC_PREPROC_IFELSE([#include <termio.h>],
        [AC_DEFINE([TERMIO],[1],TERMIO_DESCRIPTION)]
	,
        [AS_IF([test -n "$posix"],
	    [AC_TRY_CPP([#include <termios.h>],
	        [AC_DEFINE([TERMIO],[1],TERMIO_DESCRIPTION)]
            ])
	])
    )]
)
m4_popdef([TERMIO_DESCRIPTION])

dnl AC_CHECK_HEADER(shadow.h, AC_DEFINE([SHADOWPW],[1],[SHADOWPW]))
AC_CHECKING(getspnam)
AC_TRY_LINK([#include <shadow.h>], [getspnam("x");],AC_DEFINE([SHADOWPW],[1],[SHADOWPW]))

AC_CHECKING(getttyent)
AC_TRY_LINK(,[getttyent();], AC_DEFINE([GETTTYENT],[1],[GETTTYENT]))

AC_CHECKING(fdwalk)
AC_TRY_LINK([#include <stdlib.h>], [fdwalk(NULL, NULL);],AC_DEFINE([HAVE_FDWALK],[1],[HAVE_FDWALK]))

AC_CHECKING(whether memcpy/memmove/bcopy handles overlapping arguments)
AC_TRY_RUN([
main() {
  char buf[10];
  strcpy(buf, "abcdefghi");
  bcopy(buf, buf + 2, 3);
  if (strncmp(buf, "ababcf", 6))
    exit(1);
  strcpy(buf, "abcdefghi");
  bcopy(buf + 2, buf, 3);
  if (strncmp(buf, "cdedef", 6))
    exit(1);
  exit(0); /* libc version works properly.  */
}], AC_DEFINE([USEBCOPY],[1],[USEBCOPY]))

AC_TRY_RUN([
#define bcopy(s,d,l) memmove(d,s,l)
main() {
  char buf[10];
  strcpy(buf, "abcdefghi");
  bcopy(buf, buf + 2, 3);
  if (strncmp(buf, "ababcf", 6))
    exit(1);
  strcpy(buf, "abcdefghi");
  bcopy(buf + 2, buf, 3);
  if (strncmp(buf, "cdedef", 6))
    exit(1);
  exit(0); /* libc version works properly.  */
}], AC_DEFINE([USEMEMMOVE],[1],[USEMEMMOVE]))


AC_TRY_RUN([
#define bcopy(s,d,l) memcpy(d,s,l)
main() {
  char buf[10];
  strcpy(buf, "abcdefghi");
  bcopy(buf, buf + 2, 3);
  if (strncmp(buf, "ababcf", 6))
    exit(1);
  strcpy(buf, "abcdefghi");
  bcopy(buf + 2, buf, 3);
  if (strncmp(buf, "cdedef", 6))
    exit(1);
  exit(0); /* libc version works properly.  */
}], AC_DEFINE([USEMEMCPY],[1],[USEMEMCPY]))

AC_MSG_CHECKING(long file names)
(echo 1 > /tmp/conftest9012345) 2>/dev/null
(echo 2 > /tmp/conftest9012346) 2>/dev/null
val=`cat /tmp/conftest9012345 2>/dev/null`
if test -f /tmp/conftest9012345 && test "$val" = 1; then
AC_MSG_RESULT(yes)
else
AC_MSG_RESULT(no)
AC_DEFINE([NAME_MAX], [14], [name max])
fi
rm -f /tmp/conftest*

AC_MSG_CHECKING(for vsprintf)
AC_TRY_LINK(,[vsprintf(0,0,0);], AC_MSG_RESULT(yes);AC_DEFINE([USEVARARGS],[1],[USEVARARGS]), AC_MSG_RESULT(no))

AC_HEADER_DIRENT

AC_MSG_CHECKING(for setenv)
if test -z "$ac_setenv_args"; then
    AC_TRY_COMPILE(
    [#include <stdlib.h>],
    [
        setenv((char *) 0, (char *) 0, 0);
    ], ac_setenv_args=3)
fi
if test -z "$ac_setenv_args"; then
    AC_TRY_COMPILE(
    [#include <stdlib.h>],
    [
        setenv((char *) 0, (char *) 0);
    ], ac_setenv_args=2)
fi
if test -n "$ac_setenv_args"; then
    AC_DEFINE([USESETENV],[1],[USESETENV])
    if test "$ac_setenv_args" = 3; then
        AC_DEFINE([HAVE_SETENV_3],[1],[HAVE_SETENV_3])
    elif test "$ac_setenv_args" = 2; then
        AC_DEFINE([HAVE_SETENV_2],[1],[HAVE_SETENV_2])
    fi
else
    AC_MSG_RESULT(no)
    AC_MSG_CHECKING(for putenv)
    AC_TRY_LINK(,[putenv((char *)0);unsetenv((char *)0);], AC_MSG_RESULT(yes) ,  AC_MSG_RESULT(no);AC_DEFINE([NEEDPUTENV],[1],[NEEDPUTENV]))
fi
AC_MSG_CHECKING([for nl_langinfo(CODESET)])
AC_TRY_LINK([
#include <langinfo.h>
],[nl_langinfo(CODESET);], AC_MSG_RESULT(yes);AC_DEFINE([HAVE_NL_LANGINFO],[1],[HAVE_NL_LANGINFO]), AC_MSG_RESULT(no))

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

AC_ARG_ENABLE(use_locale, [  --enable-locale         use localized month/day names])
if test "$enable_use_locale" = "yes"; then
  AC_DEFINE([USE_LOCALE],[1],[USE_LOCALE])
fi
AC_ARG_ENABLE(telnet, [  --enable-telnet         enable builtin telnet])
if test "$enable_telnet" = "yes"; then
  AC_DEFINE([BUILTIN_TELNET],[1],[BUILTIN_TELNET])
fi
AC_ARG_ENABLE(colors256, [  --enable-colors256      enable support for 256 colors])
if test "$enable_colors256" = "yes"; then
  AC_DEFINE([COLORS256],[1],[COLORS256])
fi
AC_ARG_ENABLE(rxvt_osc, [  --enable-rxvt_osc       enable support for rxvt OSC codes])
if test "$enable_rxvt_osc" = "yes"; then
  AC_DEFINE([RXVT_OSC],[1],[RXVT_OSC])
fi

dnl
dnl    ****  the end  ****
dnl
if test -z "$old_CFLAGS"; then
  if test "x$CFLAGS" = "x-g"; then
    CFLAGS="-O"
  fi
fi
dnl Ptx bug workaround -- insert -lc after -ltermcap
test -n "$seqptx" && LIBS="-ltermcap -lc -lsocket -linet -lnsl -lsec -lseq"

AC_TRY_RUN(main(){exit(0);},,AC_MSG_ERROR(Can't run the compiler - internal error. Sorry.))

AC_OUTPUT(Makefile doc/Makefile, [[
# a hook for preserving undef directive in config.h
mv config.h conftest
sed -e 's@^\(.*\)defin.\( .*\) .*/\*\(.*KEEP_UNDEF_HERE\)@\1undef\2	/\*\3@' < conftest > config.h
rm -f conftest
]])

echo ""
if test -z "$AWK"; then
echo "!!! Since you have no awk you must copy the files 'comm.h.dist'"
echo "!!! and 'term.h.dist' to 'comm.h' and 'term.h'."
echo "!!! Do _not_ change the user configuration section in config.h!"
echo "Please check the pathnames in the Makefile."
else
echo "Now please check the pathnames in the Makefile and in the user"
echo "configuration section in config.h."
fi
echo "Then type 'make' to make screen. Good luck."
echo ""
