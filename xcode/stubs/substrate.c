// substrate.c
// TubeFixLegacy - link-time stand-in for CydiaSubstrate.
//
// Built by xcode/build.sh into libsubstrate.dylib with the install name of
// the real framework, so the tweaks link against it and load the device's
// CydiaSubstrate at runtime. These bodies never run on a device.

#include "../include/substrate.h"

MSImageRef MSGetImageByName(const char *file) { (void)file; return 0; }
void *MSFindSymbol(MSImageRef image, const char *name) { (void)image; (void)name; return 0; }
void MSHookFunction(void *symbol, void *replace, void **result) { (void)symbol; (void)replace; (void)result; }
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result) { (void)_class; (void)sel; (void)imp; (void)result; }
