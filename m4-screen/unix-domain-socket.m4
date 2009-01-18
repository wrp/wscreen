
AC_DEFUN([screen_UNIX_DOMAIN_SOCKET],
[

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
AC_DEFINE([SOCK_NOT_IN_FS],[1],[The unix-domain socket implementation doesn't
	create a socket in the filesystem])
)
rm -f /tmp/conftest*
fi

])
