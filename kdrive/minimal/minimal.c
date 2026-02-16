/*
 * Minimal OS backend for kdrive - no Linux-specific code (no /dev/tty, VT, etc.).
 * Use for framebuffer-only targets (e.g. Eclipse OS).
 *
 * Copyright (c) Keith Packard (original Linux backend). This minimal stub is
 * provided for systems without Linux console/VT support.
 */

#ifdef HAVE_CONFIG_H
#include <kdrive-config.h>
#endif
#include "kdrive.h"

static int MinimalInit(void)
{
	return 1;
}

static void MinimalEnable(void)
{
}

static Bool MinimalSpecialKey(KeySym sym)
{
	(void)sym;
	return FALSE;
}

static void MinimalDisable(void)
{
}

static void MinimalFini(void)
{
}

static const KdOsFuncs MinimalFuncs = {
	MinimalInit,
	MinimalEnable,
	MinimalSpecialKey,
	MinimalDisable,
	MinimalFini,
	0
};

void OsVendorInit(void)
{
	KdOsInit(&MinimalFuncs);
}
