#include <Foundation/Foundation.h>

// Minimal declaration so the class method's signature is visible here
// (this file doesn't import appheaders.h). The class itself is looked
// up at runtime via %c(GIPToast), so this adds no link dependency.
@interface GIPToast : NSObject
+ (void)showToast:(id)text forDuration:(double)duration;
@end

BOOL TRShouldLoadGoogleHooks(void);

// 1.0.6 -> 2.0.0
%ctor {
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
        [%c(GIPToast) showToast:@"Auto Migration failed! Check FAQ in cydia page for solution." forDuration:10.0];
    }
}