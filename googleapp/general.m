#import "general.h"
#include <Foundation/Foundation.h>
#import "../common/TRVersionSupport.h"

@interface NSBundle (YouTube)
-(NSString*)localizedQuantityStringForKey:(NSString*)key quantity:(NSUInteger)quantity table:(NSString*)table;
@end

// The player is handled here as a bare `id`, and these timing
// selectors aren't declared in any header this file imports. Without a
// declaration the compiler assumes an `id` return, which both warns
// ("method not found") and mismatches the `double` result type - fatal
// under -Werror. Declaring the signatures via this protocol and
// messaging the player through it fixes the type; the
// -respondsToSelector: guards at each call site keep it runtime-safe on
// versions/players where a given selector is absent.
@protocol TRPlayerTiming
- (double)currentMediaTime;
- (double)mediaTime;
- (double)totalMediaTime;
- (double)totalTime;
@end

NSString* localizedStringForKey(NSString *key)
{
  NSBundle *v2 = [NSBundle mainBundle];
  return [v2 localizedStringForKey:key value:key table:0];
}

NSString* localizedStringForKey2(NSString *key, NSUInteger quantity) {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle localizedQuantityStringForKey:key quantity:quantity table:@"Localizable"];
}

NSString* localizedStringForKey2UILib(NSString *key, NSUInteger quantity) {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle localizedQuantityStringForKey:key quantity:quantity table:@"UILib"];
}

NSString* localizedStringForKeyUILib(NSString *key) {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle localizedStringForKey:key value:key table:@"UILib"];
}



// youtube has a built in version checker... but they changed the version checker name between versions.... soooooooo
NSString* version() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

BOOL TRIsVersion2x(void) {
  static int is2x = -1;
  if (is2x == -1) {
    is2x = TRIsGoogleVersion2x(version()) ? 1 : 0;
  }
  return is2x == 1;
}

// i want to kill you youtube, or apple for this

// creates the local variable version (variable_), since the compiler or youtube changed this, and it's in too many places to do my normal checking of version.
NSString* l(NSString *local) {
  if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"] || [version() isEqualToString:@"1.1.0"] || [version() isEqualToString:@"1.2.1"]) {
    return [NSString stringWithFormat:@"%@_", local];
  } else {
    return [NSString stringWithFormat:@"_%@", local];
  }
}

NSString *TRPackageVersion(NSString *packageID) {
    NSError *err = nil;
    NSString *status = [NSString stringWithContentsOfFile:@"/var/lib/dpkg/status"
                                                 encoding:NSUTF8StringEncoding
                                                    error:&err];
    if (!status.length) return nil;

    NSArray *blocks = [status componentsSeparatedByString:@"\n\n"];
    NSString *needle = [NSString stringWithFormat:@"Package: %@", packageID];

    for (NSString *block in blocks) {
        if ([block rangeOfString:needle].location != NSNotFound) {
            for (NSString *line in [block componentsSeparatedByString:@"\n"]) {
                if ([line hasPrefix:@"Version: "]) {
                    return [line substringFromIndex:@"Version: ".length];
                }
            }
        }
    }
    return nil;
}

bool PreferencesBoolValue(NSDictionary* preferences, NSString *key, bool defaultValue) {
    id value = [preferences objectForKey:key]; 
    
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }
    
    return [value boolValue];
}

NSString * const TRLikeStateDidChangeNotification = @"TRLikeStateDidChangeNotification";

static NSMutableDictionary *TRLikeStateCache(void) {
    static NSMutableDictionary *cache = nil;
    if (!cache) {
        cache = [[NSMutableDictionary alloc] init];
    }
    return cache;
}

void TRSetCachedLikeState(NSString *videoID, TRLikeState state) {
    if (!videoID) {
        return;
    }
    [TRLikeStateCache() setObject:@(state) forKey:videoID];
    [[NSNotificationCenter defaultCenter] postNotificationName:TRLikeStateDidChangeNotification object:videoID];
}

TRLikeState TRGetCachedLikeState(NSString *videoID) {
    if (!videoID) {
        return TRLikeStateUnknown;
    }
    NSNumber *cached = [TRLikeStateCache() objectForKey:videoID];
    return cached ? (TRLikeState)[cached intValue] : TRLikeStateUnknown;
}

void TRResolveLikeDislike(NSString *videoID, BOOL passedLike, BOOL passedDislike, BOOL *outLike, BOOL *outDislike) {
    *outLike = passedLike;
    *outDislike = passedDislike;
    TRLikeState cached = TRGetCachedLikeState(videoID);
    switch (cached) {
        case TRLikeStateLiked:
            *outLike = YES;
            *outDislike = NO;
            break;
        case TRLikeStateDisliked:
            *outLike = NO;
            *outDislike = YES;
            break;
        case TRLikeStateNeutral:
            *outLike = NO;
            *outDislike = NO;
            break;
        case TRLikeStateUnknown:
        default:
            break; // no opinion - leave the app's own values alone
    }
}

double TRPlayerCurrentTime(id player) {
    if (!player) return 0;
    if ([player respondsToSelector:@selector(currentMediaTime)]) {
        return [(id<TRPlayerTiming>)player currentMediaTime];
    }
    if ([player respondsToSelector:@selector(mediaTime)]) {
        return [(id<TRPlayerTiming>)player mediaTime];
    }
    return 0;
}

double TRPlayerTotalTime(id player) {
    if (!player) return 0;
    if ([player respondsToSelector:@selector(totalMediaTime)]) {
        return [(id<TRPlayerTiming>)player totalMediaTime];
    }
    if ([player respondsToSelector:@selector(totalTime)]) {
        return [(id<TRPlayerTiming>)player totalTime];
    }
    return 0;
}

// Settings are read a lot (every play/pause, every double tap), so they
// are cached and only re-read after the settings pane posts its change
// notification.
static NSDictionary *gTRPreferencesCache = nil;

static void TRPreferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    @synchronized ([NSDictionary class]) {
        [gTRPreferencesCache release];
        gTRPreferencesCache = nil;
    }
}

NSDictionary *TRPreferences(void) {
    static BOOL registered = NO;
    @synchronized ([NSDictionary class]) {
        if (!registered) {
            registered = YES;
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, TRPreferencesChanged, CFSTR("com.legacyreborn.tubefixlegacy/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        }
        if (!gTRPreferencesCache) {
            gTRPreferencesCache = [[NSDictionary alloc] initWithContentsOfFile:TR_PREFS_PATH] ?: [[NSDictionary alloc] init];
        }
        return [[gTRPreferencesCache retain] autorelease];
    }
}

BOOL TRShortsEnabled(void) {
    return PreferencesBoolValue(TRPreferences(), @"ShortsEnabled", YES);
}

BOOL TRTweakLanguageIsRussian(void) {
    NSString *language = [TRPreferences() objectForKey:@"Language"];
    if ([language isEqualToString:@"ru"]) return YES;
    if ([language isEqualToString:@"en"]) return NO;
    NSArray *preferred = [NSLocale preferredLanguages];
    NSString *system = [preferred count] > 0 ? [preferred objectAtIndex:0] : @"en";
    return [system hasPrefix:@"ru"] || [system hasPrefix:@"uk"] || [system hasPrefix:@"be"];
}

BOOL TRPinchToFillEnabled(void) {
    return PreferencesBoolValue(TRPreferences(), @"PinchToFill", YES);
}

BOOL TRShortsPlayerEnabled(void) {
    return TRShortsEnabled() && PreferencesBoolValue(TRPreferences(), @"ShortsPlayer", YES);
}

NSString *TRShortsQuery(void) {
    id value = [TRPreferences() objectForKey:@"ShortsQuery"];
    if ([value isKindOfClass:[NSString class]] && [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        return value;
    }
    return @"#shorts";
}

BOOL TRBackgroundPlaybackEnabled(void) {
    NSDictionary *preferences = TRPreferences();
    // an earlier build had a second, unwired "Background Playback" switch
    // saving to BackgroundPlaybackEnabled - honour it if someone turned it on
    if ([[preferences objectForKey:@"BackgroundPlaybackEnabled"] boolValue]) {
        return YES;
    }
    return PreferencesBoolValue(preferences, @"BkgPlay", YES);
}

BOOL TRLockScreenControlsEnabled(void) {
    return PreferencesBoolValue(TRPreferences(), @"LockScreenControls", YES);
}

BOOL TRDoubleTapSeekEnabled(void) {
    return PreferencesBoolValue(TRPreferences(), @"DoubleTapSeek", YES);
}

int TRDoubleTapSeekSeconds(void) {
    int seconds = [[TRPreferences() objectForKey:@"DoubleTapSeekSeconds"] intValue];
    return (seconds > 0 && seconds <= 120) ? seconds : 10;
}

BOOL TRVerboseLogging(void) {
    return PreferencesBoolValue(TRPreferences(), @"DebugLogging", NO);
}

BOOL TRShouldLoadGoogleHooks(void) {
    static int shouldLoad = -1;
    if (shouldLoad == -1) {
        TRMigrateOldPreferences();
        NSString *appVersion = TRHostAppVersion();
        if (TRIsSupportedGoogleVersion(appVersion) || !TRLegacyFallbackEnabled()) {
            shouldLoad = 1;
        } else {
            NSLog(@"TubeFixLegacy: YouTube %@ isn't supported, leaving it to the legacy fallback", appVersion);
            shouldLoad = 0;
        }
    }
    return shouldLoad == 1;
}

id TRSafeValueForKey(id object, NSString *key) {
    if (!object || !key) return nil;
    @try {
        return [object valueForKey:key];
    } @catch (NSException *exception) {
        return nil;
    }
}

UIImage *TRLoadImage(NSString *name) {
    if (!name) return nil;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *directory = @"/Library/Application Support/TubeFixLegacy";
    if (scale >= 2.0) {
        // iOS 5/6 load an explicitly named @2x file at scale 1 (twice the
        // size on screen), so set the scale ourselves
        UIImage *retina = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@@2x.png", directory, name]];
        if (retina) {
            return [UIImage imageWithCGImage:retina.CGImage scale:2.0 orientation:UIImageOrientationUp];
        }
    }
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", directory, name]];
}
