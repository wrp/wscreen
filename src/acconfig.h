/* Copyright (c) 1993-2000
 *      Juergen Weigert (jnweiger@immd4.informatik.uni-erlangen.de)
 *      Michael Schroeder (mlschroe@immd4.informatik.uni-erlangen.de)
 * Copyright (c) 1987 Oliver Laumann
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program (see the file COPYING); if not, see
 * http://www.gnu.org/licenses/, or contact Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02111-1301  USA
 *
 ****************************************************************
 * $Id$ FAU
 */





/**********************************************************************
 *
 *	User Configuration Section
 */





/* 
 * define PTYROFS if the /dev/pty devices are mounted on a read-only 
 * filesystem so screen should not even attempt to set mode or group  
 * even if running as root (e.g. on TiVo).
 */
#undef PTYROFS

#undef SIMPLESCREEN
#ifndef SIMPLESCREEN
# define ZMODEM
# define BLANKER_PRG
#endif /* SIMPLESCREEN */

/* Set LOGINDEFAULT to one (1)
 * if you want entries added to /etc/utmp by default, else set it to
 * zero (0).
 * LOGINDEFAULT will be one (1) whenever LOGOUTOK is undefined!
 */
#define LOGINDEFAULT	1

/* Set LOGOUTOK to one (1)
 * if you want the user to be able to log her/his windows out.
 * (Meaning: They are there, but not visible in /etc/utmp).
 * Disabling this feature only makes sense if you have a secure /etc/utmp
 * database. 
 * Negative examples: suns usually have a world writable utmp file, 
 * xterm will run perfectly without s-bit.
 *
 * If LOGOUTOK is undefined and UTMPOK is defined, all windows are
 * initially and permanently logged in.
 *
 * Set CAREFULUTMP to one (1) if you want that users have at least one
 * window per screen session logged in.
 */
#define LOGOUTOK 1
#undef CAREFULUTMP



/*
 * both must be defined if you want to favor tcsendbreak over
 * other calls to generate a break condition on serial lines.
 * (Do not bother, if you are not using plain tty windows.)
 */
#define POSIX_HAS_A_GOOD_TCSENDBREAK
#define SUNOS4_AND_WE_TRUST_TCSENDBREAK


/*
 * Some terminals, e.g. Wyse 120, use a bitfield to select attributes.
 * This doesn't work with the standard so/ul/m? terminal entries,
 * because they will cancel each other out. 
 * On TERMINFO machines, "sa" (sgr) may work. If you want screen
 * to switch attributes only with sgr, define USE_SGR.
 * This is *not* recomended, do this only if you must.
 */
#undef USE_SGR

/*
 * Define USE_PAM if your system supports PAM (Pluggable Authentication
 * Modules) and you want screen to use it instead of calling crypt().
 * (You may also need to add -lpam to LIBS in the Makefile.)
 */
#undef USE_PAM

/*
 * Define CHECK_SCREEN_W if you want screen to set TERM to screen-w
 * if the terminal width is greater than 131 columns. No longer needed
 * on modern systems which use $COLUMNS or the tty settings instead.
 */
#undef CHECK_SCREEN_W

/**********************************************************************
 *
 *	End of User Configuration Section
 *
 *      Rest of this file is modified by 'configure'
 *      Change at your own risk!
 *
 */

/*
 * Some defines to identify special unix variants
 */

/*
 * Define BSDJOBS if you have BSD-style job control (both process
 * groups and a tty that deals correctly with them).
 */
#undef BSDJOBS

/*
 * Define CYTERMIO if you have cyrillic termio modes.
 */
#undef CYTERMIO

/*
 * Define TERMINFO if your machine emulates the termcap routines
 * with the terminfo database.
 * Thus the .screenrc file is parsed for
 * the command 'terminfo' and not 'termcap'.
 */
#undef TERMINFO

/*
 * If your library does not define ospeed, define this.
 */
#undef NEED_OSPEED

/*
 * Define SYSV if your machine is SYSV complient (Sys V, HPUX, A/UX)
 */
#ifndef SYSV
#undef SYSV
#endif

/*
 * Define SIGVOID if your signal handlers return void.  On older
 * systems, signal returns int, but on newer ones, it returns void.
 */
#undef SIGVOID 

/*
 * Define USESIGSET if you have sigset for BSD 4.1 reliable signals.
 */
#undef USESIGSET

/*
 * Define SYSVSIGS if signal handlers must be reinstalled after
 * they have been called.
 */
#undef SYSVSIGS

/*
 * Define BSDWAIT if your system defines a 'union wait' in <sys/wait.h>
 *
 * Only allow BSDWAIT i.e. wait3 on nonposix systems, since
 * posix implies wait(3) and waitpid(3). vdlinden@fwi.uva.nl
 * 
 */
#ifndef POSIX
#undef BSDWAIT
#endif

/*
 * On RISCOS we prefer wait2() over wait3(). rouilj@sni-usa.com 
 */
#ifdef BSDWAIT
#undef USE_WAIT2
#endif

/*
 * If your system has getutent(), pututline(), etc. to write to the
 * utmp file, define GETUTENT.
 */
#undef GETUTENT

/*
 * Define UTHOST if the utmp file has a host field.
 */
#undef UTHOST

/*
 * Define if you have the utempter utmp helper program
 */
#undef HAVE_UTEMPTER

/*
 * If ttyslot() breaks getlogin() by returning indexes to utmp entries
 * of type DEAD_PROCESS, then our getlogin() replacement should be
 * selected by defining BUGGYGETLOGIN.
 */
#undef BUGGYGETLOGIN

/*
 * If your system has the calls setreuid() and setregid(),
 * define HAVE_SETREUID. Otherwise screen will use a forked process to
 * safely create output files without retaining any special privileges.
 */
#undef HAVE_SETRESUID
#undef HAVE_SETREUID

/*
 * If your system supports BSD4.4's seteuid() and setegid(), define
 * HAVE_SETEUID.
 */
#undef HAVE_SETEUID

/*
 * If you want the "time" command to display the current load average
 * define LOADAV. Maybe you must install screen with the needed
 * privileges to read /dev/kmem.
 * Note that NLIST_ stuff is only checked, when getloadavg() is not available.
 */
#undef LOADAV

#undef LOADAV_NUM
#undef LOADAV_TYPE
#undef LOADAV_SCALE
#undef LOADAV_GETLOADAVG
#undef LOADAV_UNIX
#undef LOADAV_AVENRUN
#undef LOADAV_USE_NLIST64

#undef NLIST_DECLARED
#undef NLIST_STRUCT
#undef NLIST_NAME_UNION

/*
 * If your system has the new format /etc/ttys (like 4.3 BSD) and the
 * getttyent(3) library functions, define GETTTYENT.
 */
#undef GETTTYENT

/*
 * Define USEBCOPY if the bcopy/memcpy from your system's C library
 * supports the overlapping of source and destination blocks.  When
 * undefined, screen uses its own (probably slower) version of bcopy().
 * 
 * SYSV machines may have a working memcpy() -- Oh, this is 
 * quite unlikely. Tell me if you see one.
 * "But then, memmove() should work, if at all available" he thought...
 * Boing, never say "works everywhere" unless you checked SCO UNIX.
 * Their memove fails the test in the configure script. Sigh. (Juergen)
 */
#undef USEBCOPY
#undef USEMEMCPY
#undef USEMEMMOVE

/*
 * If your system has vsprintf() and requires the use of the macros in
 * "varargs.h" to use functions with variable arguments,
 * define USEVARARGS.
 */
#undef USEVARARGS

/*
 * If the select return value doesn't treat a descriptor that is
 * usable for reading and writing as two hits, define SELECT_BROKEN.
 */
#undef SELECT_BROKEN

/*
 * Define this if your system supports named pipes.
 */
#undef NAMEDPIPE

/*
 * Define this if your system exits select() immediatly if a pipe is
 * opened read-only and no writer has opened it.
 */
#undef BROKEN_PIPE

/*
 * Define this if the unix-domain socket implementation doesn't
 * create a socket in the filesystem.
 */
#undef SOCK_NOT_IN_FS

/*
 * If your system has setenv() and unsetenv() define USESETENV
 */
#undef USESETENV

/*
 * If setenv() takes 3 arguments sefine HAVE_SETENV_3
 */
#undef HAVE_SETENV_3

/*
 * If setenv() takes 2 arguments sefine HAVE_SETENV_2
 */
#undef HAVE_SETENV_2

/*
 * If your system does not come with a setenv()/putenv()/getenv()
 * functions, you may bring in our own code by defining NEEDPUTENV.
 */
#undef NEEDPUTENV

/*
 * If the passwords are stored in a shadow file and you want the
 * builtin lock to work properly, define SHADOWPW.
 */
#undef SHADOWPW

/*
 * If you are on a SYS V machine that restricts filename length to 14 
 * characters, you may need to enforce that by setting NAME_MAX to 14
 */
/* KEEP_UNDEF_HERE override system value
 * (Will this even work as expected? -mjc) */
#undef NAME_MAX
#undef NAME_MAX

/*
 * define HAVE_NL_LANGINFO if your system has the nl_langinfo() call
 * and <langinfo.h> defines CODESET.
 */
#undef HAVE_NL_LANGINFO

/*
 * Newer versions of Solaris include fdwalk, which can greatly improve
 * the startup time of screen; otherwise screen spends a lot of time
 * closing file descriptors.
 */
#undef HAVE_FDWALK

/*
 * define HAVE_DEV_PTC if you have a /dev/ptc character special
 * device.
 */
#undef HAVE_DEV_PTC

/*
 * define HAVE_SVR4_PTYS if you have a /dev/ptmx character special
 * device and support the ptsname(), grantpt(), unlockpt() functions.
 */
#undef HAVE_SVR4_PTYS

/* 
 * define PTYRANGE0 and or PTYRANGE1 if you want to adapt screen
 * to unusual environments. E.g. For SunOs the defaults are "qpr" and 
 * "0123456789abcdef". For SunOs 4.1.2 
 * #define PTYRANGE0 "pqrstuvwxyzPQRST" 
 * is recommended by Dan Jacobson.
 */
#undef PTYRANGE0
#undef PTYRANGE1

