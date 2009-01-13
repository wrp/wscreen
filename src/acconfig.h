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

/*
 * both must be defined if you want to favor tcsendbreak over
 * other calls to generate a break condition on serial lines.
 * (Do not bother, if you are not using plain tty windows.)
 */
#define POSIX_HAS_A_GOOD_TCSENDBREAK
#define SUNOS4_AND_WE_TRUST_TCSENDBREAK

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


