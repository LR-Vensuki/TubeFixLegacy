// TRVersionSupport.h
// TubeFixLegacy
//
// Single source of truth for "which YouTube app versions do the Google
// app hooks (TubeFixLegacy.dylib) actually know how to drive". Shared
// (header-only) between the googleapp and classic targets, so the two can
// never disagree about who owns a given process: on a supported version
// TubeFixLegacy.dylib runs and the classic fallback stays out of the way,
// on anything else TubeFixLegacy.dylib steps aside (see
// TRShouldLoadGoogleHooks in googleapp/general.m) and the classic
// fallback redirects the app to a TubeRepair-compatible server instead.

#import <Foundation/Foundation.h>

#define TR_PREFS_DOMAIN @"com.legacyreborn.tubefixlegacy"
#define TR_PREFS_PATH @"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"
// where TubeReplacer (and the ios6fix builds of it) kept the same settings
#define TR_OLD_PREFS_PATH @"/var/mobile/Library/Preferences/dev.preloading.tubereplacer.preferences.plist"

static inline NSString *TRHostAppVersion(void) {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// "2.1.0" -> 2, 1. Missing parts count as 0.
static inline void TRParseAppVersion(NSString *appVersion, int *major, int *minor) {
    NSArray *parts = [appVersion isKindOfClass:[NSString class]] ? [appVersion componentsSeparatedByString:@"."] : nil;
    *major = [parts count] > 0 ? [[parts objectAtIndex:0] intValue] : 0;
    *minor = [parts count] > 1 ? [[parts objectAtIndex:1] intValue] : 0;
}

// 2.x apps (YTPlayerViewController, SSO sign-in, YTStream MIME types)
// share one API shape; code that used to test for exactly "2.0.0" means
// "any 2.x" and should use this instead.
static inline BOOL TRIsGoogleVersion2x(NSString *appVersion) {
    int major, minor;
    TRParseAppVersion(appVersion, &major, &minor);
    return major == 2;
}

// The versions every hook was checked against in the real binaries.
// 2.1.x / 2.2.x run the 2.0.0 code paths; where a model initializer
// differs there, TRSelectorCompat.m remaps the call instead of crashing.
static inline BOOL TRIsVerifiedGoogleVersion(NSString *appVersion) {
    static NSSet *verifiedVersions = nil;
    if (!verifiedVersions) {
        verifiedVersions = [[NSSet alloc] initWithObjects:@"1.0.0", @"1.0.1", @"1.1.0", @"1.2.1", @"1.3.0", @"1.4.0", @"2.0.0", nil];
    }
    return [appVersion isKindOfClass:[NSString class]] && [verifiedVersions containsObject:appVersion];
}

static inline BOOL TRIsSupportedGoogleVersion(NSString *appVersion) {
    if (![appVersion isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (TRIsVerifiedGoogleVersion(appVersion)) {
        return YES;
    }
    // 2.0.x - 2.2.x, sign-in included
    int major, minor;
    TRParseAppVersion(appVersion, &major, &minor);
    return major == 2 && minor <= 2;
}

static inline BOOL TRIsGoogleYouTubeBundle(NSString *bundleID) {
    return [bundleID isKindOfClass:[NSString class]] && [bundleID hasPrefix:@"com.google.ios.youtube"];
}

static inline BOOL TRIsClassicYouTubeBundle(NSString *bundleID) {
    return [bundleID isKindOfClass:[NSString class]] && [bundleID hasPrefix:@"com.apple.youtube"];
}

// Carries settings (and the sign-in state stored with them) over from
// TubeReplacer the first time TubeFixLegacy runs. Never overwrites
// TubeFixLegacy's own file once it exists.
static inline void TRMigrateOldPreferences(void) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TR_PREFS_PATH] && [fileManager fileExistsAtPath:TR_OLD_PREFS_PATH]) {
        [fileManager copyItemAtPath:TR_OLD_PREFS_PATH toPath:TR_PREFS_PATH error:NULL];
    }
}

// Classic fallback defaults to on; turning it off restores the old
// behaviour of TubeFixLegacy.dylib loading into every Google YouTube
// version, supported or not.
static inline BOOL TRLegacyFallbackEnabled(void) {
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
    id value = [preferences objectForKey:@"LegacyFallbackEnabled"];
    return value ? [value boolValue] : YES;
}

static inline BOOL TRDebugLoggingEnabled(void) {
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
    return [[preferences objectForKey:@"DebugLogging"] boolValue];
}
