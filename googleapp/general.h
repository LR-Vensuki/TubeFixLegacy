#include <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString* localizedStringForKey(NSString *key);
NSString* localizedStringForKey2(NSString *key, NSUInteger quantity);
NSString* localizedStringForKeyUILib(NSString *key);
NSString* localizedStringForKey2UILib(NSString *key, NSUInteger quantity);
NSString* version();
// Any 2.x app (2.0.0 - 2.2.x): the YTStream MIME type initializers,
// YTPlayerViewController, SSO sign-in and so on.
BOOL TRIsVersion2x(void);
NSString* l(NSString *local);
NSString *TRPackageVersion(NSString *packageID);
bool PreferencesBoolValue(NSDictionary* preferences, NSString *key, bool defaultValue);

// Lightweight per-session cache of the person's own like/dislike
// state, keyed by video ID. Nothing here is fetched from the server -
// InnerTube's real per-video "myRating" isn't wired up yet (see the
// upstream README's "viewing whether you liked a video" TODO), so
// this only remembers what WE just successfully set via likes.x,
// for as long as the app process stays alive. That's enough to fix
// the same-session toggle (like it, then unlike it) without yet
// solving "show correct state when a video is reopened later".
typedef enum {
    TRLikeStateUnknown = 0,
    TRLikeStateLiked = 1,
    TRLikeStateDisliked = 2,
    TRLikeStateNeutral = 3
} TRLikeState;

// Posted (object = the video ID NSString) whenever TRSetCachedLikeState
// is called, so any currently-visible cell showing that video can
// immediately re-render with the corrected state.
extern NSString * const TRLikeStateDidChangeNotification;

void TRSetCachedLikeState(NSString *videoID, TRLikeState state);
// Returns TRLikeStateUnknown if we have no opinion yet, in which case
// callers should fall back to whatever the app itself would show.
TRLikeState TRGetCachedLikeState(NSString *videoID);

// Convenience for the setVideo:userLike:userDislike: hooks: only
// overrides *outLike/*outDislike when we actually have a cached
// opinion for this video ID, otherwise leaves the app's own passed-in
// values untouched.
void TRResolveLikeDislike(NSString *videoID, BOOL passedLike, BOOL passedDislike, BOOL *outLike, BOOL *outDislike);

// YTPlayer (older app versions) exposes -mediaTime/-totalTime;
// MLPlayer (newer versions) exposes -currentMediaTime/-totalMediaTime
// instead and has no -totalTime at all. Both happen to respond to
// -currentMediaTime, but only one of them has a "total" accessor
// under either name, so this picks whichever the object actually has
// instead of assuming one class or the other.
double TRPlayerCurrentTime(id player);
double TRPlayerTotalTime(id player);

// Master "Enable Shorts" toggle - governs the side-menu entry
// (categories.x) and whether Shorts found in feeds are shown at all.
// Default on, matching this file's other toggles.
BOOL TRShortsEnabled(void);

// Language of TubeFixLegacy's own texts (Shorts player, its alerts, the
// Shorts row) - "Language" in settings: auto (follow iOS), en or ru.
BOOL TRTweakLanguageIsRussian(void);
#define TRLocalized(english, russian) (TRTweakLanguageIsRussian() ? (russian) : (english))

// Tapping a Short opens TubeFixLegacy's own vertical Shorts player
// (ShortsPlayer, default on) instead of the app's regular watch page.
BOOL TRShortsPlayerEnabled(void);

// The signed-in account's GTMOAuth2Authentication (it signs InnerTube
// requests with -authorizeNSRequest:, see signin.x), or nil when nobody
// is signed in. Implemented in signin.x.
id TRCurrentSignedInAuth(void);

// Spreading two fingers on a full-screen video crops it to fill the
// screen, pinching back shows all of it again (PinchToFill, default on).
BOOL TRPinchToFillEnabled(void);

// Search query the Shorts side-menu feed is filled from (Shorts-only
// search results). Default "#shorts".
NSString *TRShortsQuery(void);

// Cached contents of TubeFixLegacy's settings plist, refreshed when the
// settings pane posts com.legacyreborn.tubefixlegacy/settingschanged.
NSDictionary *TRPreferences(void);

// "Background Playback" switch (BkgPlay, default on).
BOOL TRBackgroundPlaybackEnabled(void);

// Lock screen / multitasking bar "now playing" info and remote controls
// (LockScreenControls, default on).
BOOL TRLockScreenControlsEnabled(void);

// Double-tap the left/right side of the player to seek (DoubleTapSeek,
// default on) by DoubleTapSeekSeconds (default 10).
BOOL TRDoubleTapSeekEnabled(void);
int TRDoubleTapSeekSeconds(void);

// "Verbose Logging" switch (DebugLogging, default off), from the cached prefs.
BOOL TRVerboseLogging(void);
#define TFLLog(fmt, ...) do { if (TRVerboseLogging()) NSLog(@"[TubeFixLegacy] " fmt, ##__VA_ARGS__); } while (0)

// Whether TubeFixLegacy.dylib should hook this process at all. NO on a
// YouTube version TubeFixLegacy doesn't support while the legacy
// fallback is enabled - that tweak takes over instead, and our hooks
// would only get in its way. Cached after the first call.
BOOL TRShouldLoadGoogleHooks(void);

// -valueForKey: that returns nil instead of throwing when the key (or
// the ivar behind it) doesn't exist in this app version.
id TRSafeValueForKey(id object, NSString *key);

// Loads a bundled TubeFixLegacy image (not the app's own bundle -
// imageNamed: would look in the host YouTube app, not us) from
// /Library/Application Support/TubeFixLegacy/, picking the @2x variant
// on Retina screens. name should be given without extension or scale
// suffix, e.g. TRLoadImage(@"guide_shorts").
UIImage *TRLoadImage(NSString *name);