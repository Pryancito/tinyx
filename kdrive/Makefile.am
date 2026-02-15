if KDRIVEVESA
VESA_SUBDIRS = vesa
endif

if KDRIVEFBDEV
FBDEV_SUBDIRS = fbdev
endif

if KDRIVELINUX
LINUX_SUBDIRS = linux
endif

if KDRIVEMINIMAL
MINIMAL_SUBDIRS = minimal
endif

SUBDIRS =			\
	src			\
	$(LINUX_SUBDIRS)	\
	$(MINIMAL_SUBDIRS)	\
	$(FBDEV_SUBDIRS)	\
	$(VESA_SUBDIRS)

DIST_SUBDIRS = vesa fbdev src linux minimal
