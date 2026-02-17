AM_CPPFLAGS = 					\
	@KDRIVE_INCS@				\
	@KDRIVE_CFLAGS@

noinst_LIBRARIES = libfbdev.a

bin_PROGRAMS = Xfbdev

libfbdev_a_SOURCES =	\
	fbdev.c		\
	fbdev.h

Xfbdev_SOURCES = \
	fbinit.c

# Enlace estático: sin dependencias .so (necesario para Eclipse OS).
# -all-static es la opción de libtool que fuerza enlace estático (libtool ignora -static a veces).
# -no-pie: necesario si se enlaza con crt0_*.o.
# -Wl,--undefined=ResetFontPrivateIndex: resolver desde libxfont/libxfont2.
Xfbdev_LDFLAGS = -all-static -no-pie -Wl,--undefined=ResetFontPrivateIndex

# Con enlace estático, freetype/fontenc/png necesitan estas libs; orden: deps al final (-lz -lm para gz*, deflate*, pow)
Xfbdev_LDADD =					\
	libfbdev.a					\
	@KDRIVE_LIBS@				\
	@XSERVER_LIBS@				\
	-lpng -lbz2 -lbrotlidec -lbrotlicommon -lz -lm					

Xfbdev_DEPENDENCIES =					\
	libfbdev.a @KDRIVE_LIBS@

install-exec-hook:
if INSTALL_SETUID
	chown root $(DESTDIR)$(bindir)/Xfbdev
	chmod u+s $(DESTDIR)$(bindir)/Xfbdev
endif
