
AC_DEFUN([screen_FIFO],
[
dnl
dnl    ****  FIFO tests  ****
dnl

m4_pushdef([headers],
[/* For select - According to POSIX 1003.1-2001 */
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
#endif])

AC_CHECKING(fifos)
AC_TRY_RUN(headers
[
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
AC_TRY_RUN( headers
[
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
fi dnl
m4_popdef([headers])
])
