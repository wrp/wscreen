ACLOCAL_AMFLAGS = -I m4 -I m4-screen

SUBDIRS = lib src
EXTRA_DIST = .version m4/gnulib-cache.m4

# .version - present in a checked-out repository and in a distribution
#     tarball.  See git-version-gen.
BUILT_SOURCES = $(top_srcdir)/.version
$(top_srcdir)/.version:
	echo $(VERSION) > $@-t && mv $@-t $@

# .tarball-version - only in distribution tarballs,
#     never in a checked-out repository.  See git-version-gen.
dist-hook:
	echo $(VERSION) > $(distdir)/.tarball-version
