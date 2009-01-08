dnl screen_BOOLFEATURE( name, description, [status], [symbol],
dnl   [action-if-yes], [action-if-no])
dnl AC_ARG_ENABLE the name using the given description.
dnl status should be 'yes' or 'no', defaulting to 'no'.  If 'yes',
dnl then symbol will be AC_DEFINED to 1 unless the user specifies
dnl --disable-name at configure time.  If 'no', the symbol
dnl will be AC_DEFINED to 1 if he user specifies --enable-name.
dnl If symbol is not given, it defaults to the upper-cased name.

AC_DEFUN([screen_BOOLFEATURE],
[
	m4_pushdef([name],m4_tolower($1))
	m4_pushdef([cppname],m4_toupper(m4_ifval([$4],[$4],[$1])))
	m4_pushdef([status],m4_ifval([$3],[$3],[no]))
	m4_pushdef([cmp],m4_case(status,[yes],[!= xno],[no],[= xyes]))
	m4_pushdef([msg],m4_case(status,[yes],[--disable],[no],[--enable]))

	AC_ARG_ENABLE([name],
		[AS_HELP_STRING([msg-name], [$2])],
		[AS_IF([test x"$enable_[]name" cmp],
			[AC_DEFINE([cppname],[1],[$2])])],
		m4_if(status,[yes],
			[AC_DEFINE([cppname],[1],[$2])]
			[$5],
			m4_ifval([$6],[$6],[:])
		)
	)
	m4_ifval([$5], [AS_IF([test x"$enable_[]name" = xyes],[$5],[:])])
	m4_ifval([$6], [AS_IF([test x"$enable_[]name" = xno],[$6],[:])])
	m4_popdef([name])
	m4_popdef([status])
	m4_popdef([cmp])
	m4_popdef([msg])
	m4_popdef([cppname])
])
