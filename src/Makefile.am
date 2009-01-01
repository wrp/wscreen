## Process this file with automake to create Makefile.in
#
# Makefile template for screen 

ACLOCAL_AMFLAGS = -I m4
SUBDIRS = lib doc

ETCSCREENRC = $(prefix)/etc/screenrc
SCREENENCODINGS = $(datadir)/screen/utf8encodings

AM_CPPFLAGS = -DETCSCREENRC='"$(ETCSCREENRC)"' \
	-DSCREENENCODINGS='"$(SCREENENCODINGS)"' \
	-DGIT_REV=\"$(GIT_REV)\"

BUILT_SOURCES = term.h kmapdef.c tty.c comm.h osdef.h

bin_PROGRAMS = screen
nodist_screen_SOURCES = term.h kmapdef.c tty.c comm.h osdef.h
screen_SOURCES = screen.c ansi.c fileio.c mark.c misc.c resize.c socket.c \
	search.c term.c window.c utmp.c loadav.c putenv.c help.c \
	termcap.c input.c attacher.c pty.c process.c display.c comm.c \
	acls.c braille.c braille_tsi.c logfile.c layer.c \
	sched.c teln.c nethack.c encoding.c


install-data-hook:
	$(MKDIR_P) $(DESTDIR)$(SCREENENCODINGS)
	cp $(srcdir)/utf8encodings/?? $(DESTDIR)$(SCREENENCODINGS)

install-exec-hook:
	-if [ -d /usr/lib/terminfo ]; then \
		PATH="$$PATH:/usr/5bin" tic ${srcdir}/terminfo/screeninfo.src; \
		chmod 644 /usr/lib/terminfo/s/screen*; \
	fi
	@echo "termcap entry (${srcdir}/terminfo/screencap) should be installed manually."
	@echo "You may also want to install $(srcdir)/etc/etcscreenrc in" $(ETCSCREENRC)

installdirs:
	$(MKDIR_P) $(DESTDIR)$(bindir) $(DESTDIR)$(SCREENENCODINGS)
	cd doc ; $(MAKE) installdirs

shadow:
	mkdir shadow;
	cd shadow; ln -s ../*.[ch] ../*.in ../*.sh ../configure ../doc ../terminfo ../etc .
	rm -f shadow/term.h shadow/tty.c shadow/comm.h shadow/osdef.h
	echo "install all Makefiles and config:" > shadow/Makefile
	echo "	rm -f config.cache" >> shadow/Makefile
	echo "	sh ./configure" >> shadow/Makefile
	
term.h: term.c term.sh
	AWK=$(AWK) srcdir=$(srcdir) sh $(srcdir)/term.sh

kmapdef.c: term.sh
	AWK=$(AWK) srcdir=$(srcdir) sh $(srcdir)/term.sh

tty.c:	tty.sh 
	sh $(srcdir)/tty.sh tty.c

comm.h: comm.c comm.sh config.h
	AWK=$(AWK) CC="$(CC) $(CFLAGS)" srcdir=${srcdir} sh $(srcdir)/comm.sh

osdef.h: osdef.sh config.h osdef.h.in
	CPP="$(CPP) $(CPPFLAGS)" srcdir=${srcdir} sh $(srcdir)/osdef.sh

docs:
	cd doc; $(MAKE) dvi screen.info

dvi info screen.info:
	-cd doc; $(MAKE) $@

MOSTLYCLEANFILES = osdef0.c osdef1.sed osdef2.sed
CLEANFILES = tty.c term.h comm.h osdef.h kmapdef.c
DISTCLEAFILES = osdef.h
EXTRA_DIST = acls.h ansi.h display.h extern.h logfile.h mark.h os.h \
	layer.h patchlevel.h screen.h window.h image.h \
	osdef.h.in term.sh tty.sh comm.sh osdef.sh braille.h \
	sched.h \
	term.h \
	comm.h \
	terminfo/8bits terminfo/README terminfo/checktc.c terminfo/screencap \
	terminfo/screeninfo.src terminfo/test.txt terminfo/tetris.c \
	etc/ccdefs \
	etc/completer.zsh \
	etc/countmail \
	etc/etcscreenrc \
	etc/gr-braille.tbl \
	etc/gs-braille.tbl \
	etc/mkinstalldirs \
	etc/newsyntax \
	etc/newsyntax38 \
	etc/screenrc \
	etc/toolcheck \
	etc/us-braille.tbl \
	utf8encodings/01 \
	utf8encodings/02 \
	utf8encodings/03 \
	utf8encodings/04 \
	utf8encodings/18 \
	utf8encodings/19 \
	utf8encodings/a1 \
	utf8encodings/bf \
	utf8encodings/c2 \
	utf8encodings/c3 \
	utf8encodings/c4 \
	utf8encodings/c6 \
	utf8encodings/c7 \
	utf8encodings/c8 \
	utf8encodings/cc \
	utf8encodings/cd \
	utf8encodings/d6

