dnl screen_BOOLFEATURE( name, description, [prefix])
dnl AC_ARG_ENABLE the name using the given description.

AC_DEFUN([screen_BOOLFEATURE],
[
	m4_pushdef([name],m4_tolower($1))
	m4_pushdef([cppname],m4_toupper($3$1))
	AC_ARG_ENABLE([name],
		[AS_HELP_STRING([--enable-name], $2)],
		[AS_IF([test x"$enable_[]name" = xyes],
			[AC_DEFINE(cppname,[1],[$2])]
		)]
	)
	m4_popdef([name])
	m4_popdef([cppname])
])
