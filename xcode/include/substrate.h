// substrate.h
// TubeFixLegacy - the part of Cydia Substrate's API these tweaks use.
// Linked against xcode/stubs/substrate.c when building with Xcode; the
// real implementation is the device's
// /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate.

#ifndef TFL_SUBSTRATE_H
#define TFL_SUBSTRATE_H

#include <objc/runtime.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef const void *MSImageRef;

MSImageRef MSGetImageByName(const char *file);
void *MSFindSymbol(MSImageRef image, const char *name);
void MSHookFunction(void *symbol, void *replace, void **result);
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);

#ifdef __cplusplus
}
#endif

#endif
