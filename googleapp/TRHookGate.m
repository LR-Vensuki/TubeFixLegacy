// TRHookGate.m
// TubeFixLegacy
//
// Every Logos hook in this target is installed through MSHookMessageEx.
// The Makefile compiles the target with
//     -DMSHookMessageEx=TRGatedHookMessageEx
// so each of those calls lands here first, and on a YouTube version
// TubeFixLegacy doesn't support (see TRShouldLoadGoogleHooks) no
// hook gets installed at all. That leaves such versions untouched for
// the legacy fallback tweak, without having to wrap every .x file's
// hooks in a %group.

#import <objc/runtime.h>
#import "general.h"

// substrate.h can't be used for the real declaration here: with clang
// modules the header is built once with the -D rename applied, so it
// only ever declares TRGatedHookMessageEx.
#undef MSHookMessageEx
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);
void TRGatedHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);

void TRGatedHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result) {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }
    MSHookMessageEx(_class, sel, imp, result);
}
