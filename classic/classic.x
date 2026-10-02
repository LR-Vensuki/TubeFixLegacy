// classic.x
// TubeFixLegacy - YouTube Classic (and unsupported Google YouTube builds)
//
// YouTube Classic on iOS 6 (the "Classic YouTube App" packages install
// Apple's YouTube.app as com.apple.youtube, version 1.0.0) keeps all of
// its networking in /System/Library/PrivateFrameworks/YouTube.framework.
// Everything below was checked against that framework's iOS 6.1 binary:
//
//  - every feed URL is built as "http://" + serviceHostname() + path,
//    where serviceHostname() is an exported C function that returns
//    "gdata.youtube.com" unless com.apple.youtubeframework has a
//    ServiceHost/ConfiguredServiceHost preference.
//  - every request then goes through
//    +[YTWebServiceConfig addYouTubeHeadersToRequest:includingHostHeader:],
//    which sets "Host: gdata.youtube.com" when no custom host is
//    configured. Rewriting only the URL (what the ios6fix2 build did)
//    therefore still sends Host: gdata.youtube.com to the TubeRepair
//    server, and Cloudflare in front of it rejects that with
//    "409 error code: 1001" - so Classic showed nothing at all.
//  - the device login (applelogin1/applelogin2) and the user profile use
//    hard-coded https://www.google.com/youtube/... and
//    https://gdata.youtube.com/... URLs.
//
// So: serviceHostname() is replaced with the configured server, the Host
// header is never added, and the remaining hard-coded URLs are rewritten
// when they are turned into NSURLs. The same URL rewriting also covers
// Google YouTube builds TubeFixLegacy.dylib doesn't support.
//
// Classic also gets background playback and lock screen / headphone
// controls (see "Classic: background playback" below).

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <substrate.h>
#import "../common/TRVersionSupport.h"

#define TFL_DEFAULT_SERVER @"http://tuberepair.uptimetrackers.com"
#define TFL_YOUTUBE_FRAMEWORK "/System/Library/PrivateFrameworks/YouTube.framework/YouTube"
#define TFL_DEFAULT_API_KEY_HEADER @"X-TubeRepair-API-Key"

static BOOL gTFLActive = NO;
static BOOL gTFLDebug = NO;
#define TFLDebugLog(fmt, ...) do { if (gTFLDebug) NSLog(@"[TubeFixLegacy] " fmt, ##__VA_ARGS__); } while (0)
static NSString *gTFLServerBase = nil;   // "http://host[/path]", no trailing slash
static NSString *gTFLServiceHost = nil;  // "host[/path]", what goes after "http://"
static NSString *gTFLAPIKey = nil;
static NSString *gTFLAPIKeyHeader = nil;

static NSString *TFLNormalizedServerBase(id rawValue) {
    NSString *base = [rawValue isKindOfClass:[NSString class]] ? [rawValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : nil;
    if ([base length] == 0) {
        base = TFL_DEFAULT_SERVER;
    }
    // iOS 6 can't validate most modern TLS chains, so a bare host means http
    if ([base rangeOfString:@"://"].location == NSNotFound) {
        base = [@"http://" stringByAppendingString:base];
    }
    while ([base hasSuffix:@"/"]) {
        base = [base substringToIndex:[base length] - 1];
    }
    return base;
}

// YouTube.framework formats its URLs as "http://%@/feeds/api/...", so it
// needs the server without the scheme (a path prefix is fine).
static NSString *TFLServiceHostFromBase(NSString *base) {
    NSRange scheme = [base rangeOfString:@"://"];
    return (scheme.location == NSNotFound) ? base : [base substringFromIndex:NSMaxRange(scheme)];
}

// Returns the rewritten URL string, or nil when the URL isn't one we own.
static NSString *TFLRewrittenURLString(NSString *urlString) {
    if (!gTFLActive || ![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    // cheap reject - almost every URL in the app lands here
    if ([urlString rangeOfString:@"gdata.youtube.com"].location == NSNotFound &&
        [urlString rangeOfString:@"www.google.com/youtube/"].location == NSNotFound) {
        return nil;
    }

    static NSArray *hostPrefixes = nil;
    if (!hostPrefixes) {
        hostPrefixes = [[NSArray alloc] initWithObjects:
            @"http://gdata.youtube.com",
            @"https://gdata.youtube.com",
            @"http://www.google.com/youtube/",
            @"https://www.google.com/youtube/",
            nil];
    }

    for (NSString *prefix in hostPrefixes) {
        NSRange range = [urlString rangeOfString:prefix options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
        if (range.location == NSNotFound) {
            continue;
        }
        NSString *rest = [urlString substringFromIndex:NSMaxRange(range)];
        if ([prefix hasSuffix:@"/youtube/"]) {
            return [NSString stringWithFormat:@"%@/youtube/%@", gTFLServerBase, rest];
        }
        // make sure this really was the gdata host and not e.g. gdata.youtube.com.example
        if ([rest length] > 0 && ![rest hasPrefix:@"/"] && ![rest hasPrefix:@"?"] && ![rest hasPrefix:@":"]) {
            return nil;
        }
        if ([rest hasPrefix:@":"]) {
            // drop an explicit port, the server has its own
            NSRange slash = [rest rangeOfString:@"/"];
            rest = (slash.location == NSNotFound) ? @"" : [rest substringFromIndex:slash.location];
        }
        return [gTFLServerBase stringByAppendingString:rest];
    }
    return nil;
}

static NSURL *TFLRewrittenURL(NSURL *url) {
    if (!gTFLActive || ![url isKindOfClass:[NSURL class]]) {
        return nil;
    }
    NSString *rewritten = TFLRewrittenURLString([url absoluteString]);
    return rewritten ? [NSURL URLWithString:rewritten] : nil;
}

static void TFLLogRedirect(NSString *from, NSString *to) {
    if (gTFLDebug) {
        NSLog(@"[TubeFixLegacy] %@ -> %@", from, to);
    }
}

// A "Host:" header naming one of Google's hosts, on a request that no
// longer goes to Google.
static BOOL TFLIsGoogleHostHeader(NSString *field, NSString *value) {
    if (!gTFLActive || ![field isKindOfClass:[NSString class]] || [field caseInsensitiveCompare:@"Host"] != NSOrderedSame) {
        return NO;
    }
    return [value isKindOfClass:[NSString class]] &&
        ([value rangeOfString:@"youtube.com" options:NSCaseInsensitiveSearch].location != NSNotFound ||
         [value rangeOfString:@"google.com" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

static void TFLAddAPIKeyIfNeeded(NSURLRequest *request) {
    if (!gTFLAPIKey || ![request isKindOfClass:[NSMutableURLRequest class]]) {
        return;
    }
    NSString *urlString = [[request URL] absoluteString];
    if ([urlString hasPrefix:gTFLServerBase]) {
        [(NSMutableURLRequest *)request setValue:gTFLAPIKey forHTTPHeaderField:gTFLAPIKeyHeader];
    }
}

%hook NSURL

+ (id)URLWithString:(NSString *)URLString
{
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return %orig(rewritten ?: URLString);
}

+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL
{
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return %orig(rewritten ?: URLString, baseURL);
}

- (id)initWithString:(NSString *)URLString
{
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return %orig(rewritten ?: URLString);
}

- (id)initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL
{
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return %orig(rewritten ?: URLString, baseURL);
}

%end

%hook NSURLRequest

- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSURL *rewritten = TFLRewrittenURL(URL);
    id request = %orig(rewritten ?: URL, cachePolicy, timeoutInterval);
    TFLAddAPIKeyIfNeeded(request);
    return request;
}

%end

%hook NSMutableURLRequest

- (void)setURL:(NSURL *)URL
{
    NSURL *rewritten = TFLRewrittenURL(URL);
    %orig(rewritten ?: URL);
    TFLAddAPIKeyIfNeeded(self);
}

// Belt and braces for the Host header: whoever sets it, a Google host
// must not be sent to the replacement server.
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if (TFLIsGoogleHostHeader(field, value)) {
        return;
    }
    %orig;
}

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if (TFLIsGoogleHostHeader(field, value)) {
        return;
    }
    %orig;
}

%end

#pragma mark - YouTube.framework (Classic)

%group ClassicFramework

%hook YTWebServiceConfig

+ (void)addYouTubeHeadersToRequest:(NSMutableURLRequest *)request includingHostHeader:(BOOL)includeHostHeader
{
    %orig(request, NO);
    TFLAddAPIKeyIfNeeded(request);
}

%end

// Device login. Before anything else the framework "logs the device in"
// (applelogin1/2), signing a nonce with the device certificate it gets
// from lockdownd. Many jailbroken iPhones - activated with a bypass, or
// restored without Apple's activation - have no such certificate:
// liblockdown logs "Could not lookup device certification",
// -_authenticate1 returns NO and the app only says "Cannot connect to
// YouTube". TubeRepair-compatible servers answer the login with random
// values and never look at the device anyway, so skip it: hand out a
// local token and report success the way -_succeeded does after a real
// login (checked against YouTube.framework from iOS 6.1.3).
@protocol TFLDeviceAuthenticator
- (void)_succeeded;
@end

%hook YTDeviceAuthenticator

- (void)authenticate
{
    Ivar tokenIvar = class_getInstanceVariable([self class], "_token");
    Ivar timeIvar = class_getInstanceVariable([self class], "_timeTokenGranted");
    if (!tokenIvar || !timeIvar || ![self respondsToSelector:@selector(_succeeded)]) {
        %orig;
        return;
    }
    id oldToken = object_getIvar(self, tokenIvar);
    object_setIvar(self, tokenIvar, [@"TubeFixLegacy" copy]);
    [oldToken release];
    *(double *)((char *)self + ivar_getOffset(timeIvar)) = [NSDate timeIntervalSinceReferenceDate];
    TFLDebugLog(@"device login skipped (local token)");
    // a real login finishes asynchronously; callers set up their state
    // after -authenticate returns
    [self performSelector:@selector(_succeeded) withObject:nil afterDelay:0];
}

- (BOOL)canAuthenticate
{
    return YES;
}

%end

%end

#pragma mark - Classic: background playback and lock screen controls
//
// Classic plays through YTMoviePlayerViewController, a subclass of
// MPMoviePlayerViewController. In MediaPlayer.framework (iOS 6.1):
//  - MPMoviePlayerViewController stops the movie when the app enters the
//    background unless -[MPMoviePlayerControllerNew
//    _shouldContinuePlaybackInBackground] says YES (only AirPlay does);
//  - MPAVController pauses on background / lock unless the app's
//    NSUserDefaults has PlayVideoInBackground = YES (read in -init).
// The Classic app itself doesn't pause anything, declares the audio
// background mode, and has no remote control / now playing support.

@protocol TFLClassicVideo
- (NSString *)title;
- (NSString *)author;
- (NSString *)ID;
@end

static MPMoviePlayerController *gTFLMoviePlayer = nil; // retained while it's the one playing
static NSMutableDictionary *gTFLArtwork = nil;         // video ID -> MPMediaItemArtwork

static BOOL TFLPrefBool(NSString *key, BOOL defaultValue) {
    id value = [[NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH] objectForKey:key];
    return value ? [value boolValue] : defaultValue;
}

static BOOL TFLClassicBackgroundEnabled(void) {
    return TFLPrefBool(@"BkgPlay", YES);
}

static BOOL TFLClassicLockScreenEnabled(void) {
    return TFLPrefBool(@"LockScreenControls", YES);
}

static int TFLClassicSeekStep(void) {
    int seconds = [[[NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH] objectForKey:@"DoubleTapSeekSeconds"] intValue];
    return (seconds > 0 && seconds <= 120) ? seconds : 10;
}

// The Classic app plays through YTMoviePlayerViewController, which keeps
// the video in its _video ivar (YTController's _playingVideo is only set
// for the embedded player).
static id gTFLClassicPlayerViewController = nil; // not retained, cleared in -dealloc

static id TFLClassicPlayingVideo(void) {
    if (gTFLClassicPlayerViewController) {
        Ivar videoIvar = class_getInstanceVariable(object_getClass(gTFLClassicPlayerViewController), "_video");
        id video = videoIvar ? object_getIvar(gTFLClassicPlayerViewController, videoIvar) : nil;
        if (video) {
            return video;
        }
    }
    Class controllerClass = objc_getClass("YTController");
    if (![controllerClass respondsToSelector:@selector(sharedController)]) {
        return nil;
    }
    id controller = [controllerClass performSelector:@selector(sharedController)];
    @try {
        return [controller valueForKey:@"playingVideo"];
    } @catch (NSException *exception) {
        return nil;
    }
}

static void TFLClassicUpdateNowPlaying(void);

static void TFLClassicLoadArtwork(id video) {
    NSString *videoID = [video respondsToSelector:@selector(ID)] ? [(id<TFLClassicVideo>)video ID] : nil;
    if (![videoID isKindOfClass:[NSString class]] || [gTFLArtwork objectForKey:videoID]) {
        return;
    }
    [gTFLArtwork setObject:[NSNull null] forKey:videoID]; // loading
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://i.ytimg.com/vi/%@/hqdefault.jpg", videoID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if (!image) {
            [gTFLArtwork removeObjectForKey:videoID];
            return;
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [gTFLArtwork setObject:artwork forKey:videoID];
        [artwork release];
        TFLClassicUpdateNowPlaying();
    }];
}

static void TFLClassicUpdateNowPlaying(void) {
    MPMoviePlayerController *player = gTFLMoviePlayer;
    if (!player || !TFLClassicLockScreenEnabled()) {
        return;
    }
    id video = TFLClassicPlayingVideo();
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    NSString *title = [video respondsToSelector:@selector(title)] ? [(id<TFLClassicVideo>)video title] : nil;
    NSString *author = [video respondsToSelector:@selector(author)] ? [(id<TFLClassicVideo>)video author] : nil;
    [info setObject:([title isKindOfClass:[NSString class]] ? title : @"YouTube") forKey:MPMediaItemPropertyTitle];
    if ([author isKindOfClass:[NSString class]]) {
        [info setObject:author forKey:MPMediaItemPropertyArtist];
    }
    [info setObject:@"YouTube" forKey:MPMediaItemPropertyAlbumTitle];
    NSTimeInterval duration = [player duration];
    NSTimeInterval elapsed = [player currentPlaybackTime];
    if (!isnan(duration) && duration > 0) {
        [info setObject:[NSNumber numberWithDouble:duration] forKey:MPMediaItemPropertyPlaybackDuration];
    }
    [info setObject:[NSNumber numberWithDouble:(isnan(elapsed) ? 0 : elapsed)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [info setObject:[NSNumber numberWithDouble:([player playbackState] == MPMoviePlaybackStatePlaying ? 1.0 : 0.0)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    NSString *videoID = [video respondsToSelector:@selector(ID)] ? [(id<TFLClassicVideo>)video ID] : nil;
    id artwork = [videoID isKindOfClass:[NSString class]] ? [gTFLArtwork objectForKey:videoID] : nil;
    if ([artwork isKindOfClass:[MPMediaItemArtwork class]]) {
        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    } else if (video) {
        TFLClassicLoadArtwork(video);
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    TFLDebugLog(@"now playing: %@ - %@ (%.0f/%.0f s)", [info objectForKey:MPMediaItemPropertyTitle], [info objectForKey:MPMediaItemPropertyArtist], elapsed, duration);
}

static void TFLClassicForgetPlayer(MPMoviePlayerController *player) {
    if (player && player != gTFLMoviePlayer) {
        return;
    }
    [gTFLMoviePlayer release];
    gTFLMoviePlayer = nil;
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

static void TFLClassicPlaybackStateChanged(NSNotification *notification) {
    MPMoviePlayerController *player = [notification object];
    if (![player isKindOfClass:[MPMoviePlayerController class]]) {
        return;
    }
    MPMoviePlaybackState state = [player playbackState];
    if (state == MPMoviePlaybackStatePlaying) {
        if (player != gTFLMoviePlayer) {
            [gTFLMoviePlayer release];
            gTFLMoviePlayer = [player retain];
        }
        if (TFLClassicBackgroundEnabled() || TFLClassicLockScreenEnabled()) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            if (![[session category] isEqualToString:AVAudioSessionCategoryPlayback]) {
                [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
            }
            [session setActive:YES error:NULL];
        }
        if (TFLClassicLockScreenEnabled()) {
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }
    }
    if (player == gTFLMoviePlayer) {
        if (state == MPMoviePlaybackStateStopped) {
            TFLClassicForgetPlayer(player);
        } else {
            TFLClassicUpdateNowPlaying();
        }
    }
}

static BOOL TFLClassicHandleRemoteControl(UIEvent *event) {
    MPMoviePlayerController *player = gTFLMoviePlayer;
    if ([event type] != UIEventTypeRemoteControl || !player || !TFLClassicLockScreenEnabled()) {
        return NO;
    }
    BOOL playing = [player playbackState] == MPMoviePlaybackStatePlaying;
    switch ([event subtype]) {
        case UIEventSubtypeRemoteControlPlay:
            [player play];
            break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop:
            [player pause];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (playing) {
                [player pause];
            } else {
                [player play];
            }
            break;
        case UIEventSubtypeRemoteControlNextTrack:
        case UIEventSubtypeRemoteControlPreviousTrack: {
            NSTimeInterval step = TFLClassicSeekStep();
            NSTimeInterval target = [player currentPlaybackTime] + (([event subtype] == UIEventSubtypeRemoteControlNextTrack) ? step : -step);
            NSTimeInterval duration = [player duration];
            if (target < 0 || isnan(target)) target = 0;
            if (!isnan(duration) && duration > 1 && target > duration - 1) target = duration - 1;
            [player setCurrentPlaybackTime:target];
            break;
        }
        default:
            return NO;
    }
    TFLClassicUpdateNowPlaying();
    return YES;
}

%group ClassicPlayback

%hook YTMoviePlayerViewController

- (id)initWithVideo:(id)video context:(id)context delegate:(id)delegate
{
    self = %orig;
    if (self) {
        gTFLClassicPlayerViewController = self;
    }
    return self;
}

// next / previous video in the list
- (void)_updateForCurrentVideo
{
    %orig;
    gTFLClassicPlayerViewController = self;
    TFLClassicUpdateNowPlaying();
}

- (void)dealloc
{
    if (gTFLClassicPlayerViewController == self) {
        gTFLClassicPlayerViewController = nil;
    }
    %orig;
}

%end

%hook MPMoviePlayerControllerNew

- (BOOL)_shouldContinuePlaybackInBackground
{
    return TFLClassicBackgroundEnabled() ? YES : %orig;
}

%end

%hook UIApplication

- (void)sendEvent:(UIEvent *)event
{
    if ([event type] == UIEventTypeRemoteControl && TFLClassicHandleRemoteControl(event)) {
        return;
    }
    %orig;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (TFLClassicHandleRemoteControl(event)) {
        return;
    }
    %orig;
}

%end

%end

static void TFLSetUpClassicPlayback(void) {
    gTFLArtwork = [[NSMutableDictionary alloc] init];
    if (TFLClassicBackgroundEnabled()) {
        // read by -[MPAVController init]; registration domain only, nothing is saved
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"PlayVideoInBackground"]];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TFLClassicPlaybackStateChanged(notification);
    }];
    [center addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TFLClassicForgetPlayer([notification object]);
    }];
    %init(ClassicPlayback);
}

#pragma mark - YouTube.framework hooks

static NSString *(*tfl_orig_serviceHostname)(void) = NULL;

static NSString *tfl_serviceHostname(void) {
    if (gTFLActive && gTFLServiceHost) {
        return gTFLServiceHost;
    }
    return tfl_orig_serviceHostname ? tfl_orig_serviceHostname() : @"gdata.youtube.com";
}

// YouTube.framework is a direct dependency of the Classic app, so it is
// already loaded when this constructor runs.
static void TFLHookYouTubeFramework(void) {
    void *handle = dlopen(TFL_YOUTUBE_FRAMEWORK, RTLD_LAZY | RTLD_NOLOAD);
    if (!handle) {
        NSLog(@"[TubeFixLegacy] YouTube.framework isn't loaded, only rewriting URLs");
        return;
    }
    void *serviceHostname = dlsym(handle, "serviceHostname");
    if (serviceHostname) {
        MSHookFunction(serviceHostname, (void *)&tfl_serviceHostname, (void **)&tfl_orig_serviceHostname);
    } else {
        NSLog(@"[TubeFixLegacy] serviceHostname() not found in YouTube.framework");
    }
    if (objc_getClass("YTWebServiceConfig")) {
        %init(ClassicFramework);
    }
    dlclose(handle);
}

%ctor
{
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        BOOL isClassic = TRIsClassicYouTubeBundle(bundleID);
        BOOL isUnsupportedGoogle = TRIsGoogleYouTubeBundle(bundleID) && !TRIsSupportedGoogleVersion(TRHostAppVersion());
        if (!(isClassic || isUnsupportedGoogle)) {
            return;
        }

        TRMigrateOldPreferences();
        gTFLDebug = TRDebugLoggingEnabled();
        if (isClassic) {
            // independent of the server redirect below
            TFLSetUpClassicPlayback();
        }
        if (!TRLegacyFallbackEnabled()) {
            NSLog(@"[TubeFixLegacy] classic fallback is turned off in settings");
            return;
        }

        NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
        gTFLServerBase = [TFLNormalizedServerBase([preferences objectForKey:@"LegacyFallbackServerURL"]) copy];
        gTFLServiceHost = [TFLServiceHostFromBase(gTFLServerBase) copy];
        id apiKey = [preferences objectForKey:@"LegacyFallbackAPIKey"];
        if ([apiKey isKindOfClass:[NSString class]] && [apiKey length] > 0) {
            gTFLAPIKey = [apiKey copy];
            id header = [preferences objectForKey:@"LegacyFallbackAPIKeyHeader"];
            gTFLAPIKeyHeader = [(([header isKindOfClass:[NSString class]] && [header length] > 0) ? header : TFL_DEFAULT_API_KEY_HEADER) copy];
        }
        gTFLActive = YES;
        NSLog(@"[TubeFixLegacy] %@ %@: redirecting YouTube API traffic to %@", bundleID, TRHostAppVersion(), gTFLServerBase);

        %init;
        if (isClassic) {
            TFLHookYouTubeFramework();
        }
    }
}
