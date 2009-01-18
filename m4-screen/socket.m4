
AC_DEFUN([screen_SOCKET],
[
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
])
