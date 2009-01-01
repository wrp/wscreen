

dnl screen_VARTYPE( name, default, type, description, [headers], [body])
dnl Set an AC_ARG_VAR and validate it as a variable of the correct type.
AC_DEFUN([screen_VARTYPE],
[
	AC_ARG_VAR([$1],[$4])
	m4_if([$2],[],[],
		AC_DEFINE_UNQUOTED(m4_toupper([$1]),[${$1-$2}],[$4])
		AC_COMPILE_IFELSE([AC_LANG_PROGRAM([$5],
			[$6 $3 x = m4_toupper($1);])],
			[],
			dnl Try again after quoting the argument.
			[$1=\"@S|@$1\"]
			AC_DEFINE_UNQUOTED(m4_toupper([$1]),[${$1-$2}],[$4])
			AC_COMPILE_IFELSE([AC_LANG_PROGRAM([$5],
			[$6 $3 x = m4_toupper($1);])],
			[], AC_MSG_ERROR([$1=@S|@$1 must be of type $3]))
		)
	)
])
