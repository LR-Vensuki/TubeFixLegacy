#line 1 "googleapp/migration.x"
#include <Foundation/Foundation.h>




@interface GIPToast : NSObject
+ (void)showToast:(id)text forDuration:(double)duration;
@end

BOOL TRShouldLoadGoogleHooks(void);



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"");

@class GIPToast; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPToast(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPToast"); } return _klass; }
#line 13 "googleapp/migration.x"
static __attribute__((constructor)) void _logosLocalCtor_ee39cf58(int __unused argc, char __unused **argv, char __unused **envp) {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }
    NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    if ([preferences[@"StreamType"] isEqualToString:@"adaptive"] || [preferences[@"StreamType"] isEqualToString:@"360p"] || [preferences[@"StreamType"] isEqualToString:@"360pvr"]) {
        preferences[@"StreamType"] = @"web";
        [preferences writeToFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist" atomically:YES];
    }

    preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    if ([preferences[@"StreamType"] isEqualToString:@"adaptive"] || [preferences[@"StreamType"] isEqualToString:@"360p"] || [preferences[@"StreamType"] isEqualToString:@"360pvr"]) {
        [_logos_static_class_lookup$GIPToast() showToast:@"Auto Migration failed! Check FAQ in cydia page for solution." forDuration:10.0];
    }
}
#line 28 "googleapp/migration.x"
