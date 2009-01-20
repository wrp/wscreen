
AC_DEFUN([screen_USER_CONFIG],[dnl
# User configuration section.

screen_VARTYPE([maxwin],[40],[int],[Maximum of simultaneously allowed windows per screen session.])
screen_VARTYPE([sockdir],["(eff_uid ? \"/tmp/uscreens\" : \"/tmp/screens\")"],[char *],
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
    ],[],[int eff_uid;])


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

screen_VARTYPE([ttyvmin],[100],[int],[VMIN setting for the tty])
screen_VARTYPE([ttyvtime],[2],[int],[VTIME setting for the tty])
screen_BOOLFEATURE([sysscreenrc], [Do not allow the variable SYSSCREENRC
	 to specify a global sreenrc],[yes],[allow_sysscreenrc])

screen_BOOLFEATURE([lockpty],[
	If screen is NOT installed set-uid root, screen can provide tty
	security by exclusively locking the ptys.  While this keeps other
	users from opening your ptys, it also keeps your own subprocesses
	from being able to open /dev/tty.  Define LOCKPTY to add this
	exclusive locking.])

screen_BOOLFEATURE([topstat],[ If you'd rather see the [status] line on the
	first line of your terminal rather than the last, define TOPSTAT.])

screen_BOOLFEATURE([nethack],[generate nethack friendly error messages],[yes])
screen_BOOLFEATURE([checklogin], [force Screen users to enter their Unix
	 password in addition to the screen password.], [yes])

dnl If UTMPOK is defined and your system (incorrectly) counts logins by
dnl counting non-null entries in /etc/utmp (instead of counting non-null
dnl entries with no hostname that are not on a pseudo tty), define USRLIMIT
dnl to have screen put an upper-limit on the number of entries to write into
dnl /etc/utmp.  This helps to keep you from exceeding a limited-user license.
screen_BOOLFEATURE([utmpok], [define if screen has permission to update /etc/utmp], [yes])
screen_VARTYPE([usrlimit],[],[int],[Maximum number of entries to write in /etc/utmp])

screen_BOOLFEATURE([DETACH], [disallow detaching], [yes])
screen_BOOLFEATURE([LOCK], [disallow a lock program for a screenlock], [yes])
screen_BOOLFEATURE([PASSWORD], [disallow secure reattach of your screen], [yes])
screen_BOOLFEATURE([COPY_PASTE], [disallow use the famous hacker's treasure zoo], [yes])
screen_BOOLFEATURE([POW_DETACH], [disallow detach_and_logout key], [yes])
screen_BOOLFEATURE([REMOTE_DETACH], [disallow -d option to move screen between terminals], [yes])
screen_BOOLFEATURE([AUTO_NUKE], [disable Tim MacKenzies clear screen nuking], [yes])
screen_BOOLFEATURE([PSEUDOS], [disable window input/output filtering], [yes])
screen_BOOLFEATURE([MULTI], [disable multiple attaches], [yes])
screen_BOOLFEATURE([MULTIUSER], [do not allow other users in the acl to attach to your session], [yes])
screen_BOOLFEATURE([MAPKEYS], [do not include input keyboard translation], [yes])
screen_BOOLFEATURE([FONT], [disable support for ISO2022/alternet charset support], [yes])
screen_BOOLFEATURE([COLOR], [disable ansi color support], [yes])
screen_BOOLFEATURE([DW_CHARS], [do not include support for double-width character sets], [yes])
screen_BOOLFEATURE([ENCODINGS], [do not include support for encodings like euc or big5], [yes])
screen_BOOLFEATURE([UTF8], [disable support for UTF-8 encoding], [yes])
screen_BOOLFEATURE([COLORS16], [do not use 16 colors], [yes])
screen_BOOLFEATURE([zmodem], [zmodem], [yes])
screen_BOOLFEATURE([blanker_prg], [blanker_prg], [yes])
screen_BOOLFEATURE([braille], [define if you have a braille display], [no], [have_braille])
screen_BOOLFEATURE([pam], [enable Pluggable Authentication Modules], [no], [use_pam],
	AC_CHECK_HEADERS([security/pam_appl.h pam/pam_appl.h])
	AC_CHECK_LIB([pam],[pam_start])
)
screen_BOOLFEATURE([logindefault], [do not add entries to /etc/utmp], [yes])
screen_BOOLFEATURE([logoutok], [
	logoutok should be enabled if you want the user to be able to log
	her/his windows out.  (Meaning: They are there, but not visible in
	/etc/utmp).  Disabling this feature only makes sense if you have a
	secure /etc/utmp database.
	Negative examples: suns usually have a world writable utmp file,
	xterm will run perfectly without s-bit.
	If LOGOUTOK is disabled and UTMPOK is enabled, all windows are
	initially and permanently logged in.], [yes])
screen_BOOLFEATURE([carefulutmp], [
	Enable CAREFULUTMP if you want that users have at least one
	window per screen session logged in.])
screen_BOOLFEATURE([cytermio], [if you have cyrillic termio modes])
screen_BOOLFEATURE([check_screen_w],[set TERM to 'screen-w' if the terminal width
	is greater than 131.  (Obsolete)])
screen_BOOLFEATURE([ptyrofs], [enable if the /dev/pty devices are mounted on
	a read-only filesystem so screen should not even attempt to set mode
	or group even if running as root (e.g. on TiVo).])
screen_BOOLFEATURE([use_sgr],[
	Some terminals, e.g. Wyse 120, use a bitfield to select
	attributes.  This doesn't work with the standard so/ul/m?
	terminal entries, because they will cancel each other out.
	On TERMINFO machines, "sa" (sgr) may work. If you want
	screen to switch attributes only with sgr, enable USE_SGR.
	This is *not* recomended, do this only if you must.])
])
