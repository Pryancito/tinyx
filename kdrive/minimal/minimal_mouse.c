/*
 * Minimal mouse stub - no input devices. Same symbol names as Linux backend.
 */

#ifdef HAVE_CONFIG_H
#include <kdrive-config.h>
#endif
#include "kdrive.h"

static Bool MinimalMouseInit(void)
{
	return TRUE;  /* Report success but register no fd */
}

static void MinimalMouseFini(void)
{
}

const KdMouseFuncs LinuxMouseFuncs = {
	MinimalMouseInit,
	MinimalMouseFini,
};
