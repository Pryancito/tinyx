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

# Force resolver ResetFontPrivateIndex desde libxfont/libxfont2 (evita undefined ref con estáticos+LTO)
# -no-pie: necesario si se enlaza con crt0_*.o (compilados con -fno-PIE); evita "relocation R_X86_64_32 can not be used when making a PIE object"
Xfbdev_LDFLAGS = -Wl,--undefined=ResetFontPrivateIndex -no-pie

Xfbdev_LDADD = 						\
	libfbdev.a					\
	@KDRIVE_LIBS@					\
	@XSERVER_LIBS@					

Xfbdev_DEPENDENCIES =					\
	libfbdev.a @KDRIVE_LIBS@

install-exec-hook:
if INSTALL_SETUID
	chown root $(DESTDIR)$(bindir)/Xfbdev
	chmod u+s $(DESTDIR)$(bindir)/Xfbdev
endif
