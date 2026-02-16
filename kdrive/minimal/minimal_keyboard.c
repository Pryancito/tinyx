/*
 * Minimal keyboard stub - no Linux console, no input. Same symbol names as
 * Linux backend so fbdev/vesa init code does not need to change.
 */

#ifdef HAVE_CONFIG_H
#include <kdrive-config.h>
#endif
#include "kdrive.h"
#include "kkeymap.h"

extern int kdMinScanCode;
extern int kdMaxScanCode;

static void MinimalKeyboardLoad(void)
{
	kdMinScanCode = 8;
	kdMaxScanCode = 8;
}

static int MinimalKeyboardInit(void)
{
	return 0;  /* No keyboard device */
}

static void MinimalKeyboardLeds(int leds)
{
	(void)leds;
}

static void MinimalKeyboardBell(int volume, int pitch, int duration)
{
	(void)volume;
	(void)pitch;
	(void)duration;
}

static void MinimalKeyboardFini(void)
{
}

const KdKeyboardFuncs LinuxKeyboardFuncs = {
	MinimalKeyboardLoad,
	MinimalKeyboardInit,
	MinimalKeyboardLeds,
	MinimalKeyboardBell,
	MinimalKeyboardFini,
	0
};
