// playback.x
// TubeFixLegacy
//
// Background playback, lock screen / multitasking bar "now playing" info
// and remote controls (lock screen, headphones, multitasking bar) for the
// Google YouTube app, plus the playback helpers from TRPlayback.h.
//
// Every hook point below was checked against the real app binaries of
// 1.0.0, 1.0.1, 1.1.0, 1.2.1, 1.3.0, 1.4.0 and 2.1.0 (as a stand-in for
// 2.0.0). What the apps do themselves:
//
//  - 1.1.0 - 1.4.0: YTPlayerController -appWillResignActive pauses the
//    player unless its backgroundPlaybackAllowed_ ivar is set, and
//    YTPlayer/MLPlayer -appDidEnterBackground detach the AVPlayer from its
//    layer (so iOS doesn't pause it) only when *their* ivar is set. Both
//    read the ivar directly, so hooking the getters (what the old build
//    did) changed nothing - the setters have to be called.
//  - 2.x: MLPlayer's flag is called hiddenPlaybackAllowed; the controller
//    (YTPlayerViewController) asks the player through the getter.
//  - 1.0.x has no such flag at all: -appWillResignActive calls
//    pauseAndReleasePlayer, and the AVPlayer stays attached to its layer.
//  - 1.0.x uses the Ambient audio session category, which iOS silences in
//    the background and on the lock screen; 1.2.1+ switch to MediaPlayback
//    at startup.
//  - None of them set MPNowPlayingInfoCenter or handle remote control
//    events. The old build only did that from -playbackDidPlay, which only
//    exists in 1.0.x - on every later version the lock screen stayed empty.
//
// Play/pause/finish notifications per version:
//   1.0.x          -[YTPlayerController playbackDidPlay/Pause/Finish]
//   1.1.0 - 1.4.0  -[YTPlayerController playerStateDidChangeToPlaying/Paused/Finished]
//   2.x            -[YTPlayerViewController playerStateDidChangeToPlaying/Paused/Finished]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "general.h"
#import "TRPlayback.h"
#import "../common/TRVersionSupport.h"

// Everything here is messaged as a bare id; this only gives the compiler
// the right signatures (the double/unsigned returns matter on armv7).
@protocol TFLPlaybackMessages
- (void)didPressPlay;
- (void)didPressPause;
- (BOOL)isPlaying;
- (void)play;
- (void)pause;
- (void)seekToTime:(double)time;
- (void)setBackgroundPlaybackAllowed:(BOOL)allowed;
- (void)setHiddenPlaybackAllowed:(BOOL)allowed;
- (id)videoOrAdVideo;
- (id)video;
- (NSString *)title;
- (NSString *)uploaderDisplayName;
- (unsigned int)duration;
- (NSDictionary *)thumbnailURLs;
- (NSString *)ID;
- (id)playerLayer;
@end

#pragma mark - Playback helpers

static id gTRActivePlayerController = nil; // not retained

void TRSetActivePlayerController(id controller) {
    gTRActivePlayerController = controller;
}

void TRClearActivePlayerController(id controller) {
    if (gTRActivePlayerController == controller) {
        gTRActivePlayerController = nil;
    }
}

id TRActivePlayerController(void) {
    return gTRActivePlayerController;
}

id TRPlayerControllerForPlayerView(UIView *playerView) {
    id controller = TRSafeValueForKey(playerView, l(@"playerViewDelegate"));
    if (!controller) {
        controller = TRSafeValueForKey(playerView, l(@"delegate"));
    }
    return controller;
}

id TRPlayerOfController(id controller) {
    return controller ? TRSafeValueForKey(controller, l(@"player")) : nil;
}

// YTPlayer_iOS5 keeps its AVPlayer in avPlayer_, YTPlayer/MLPlayer in (_)player(_)
static AVPlayer *TRAVPlayerOfPlayer(id player) {
    if (!player) return nil;
    if ([player isKindOfClass:[AVPlayer class]]) return player;
    NSArray *keys = [NSArray arrayWithObjects:@"player", @"avPlayer", nil];
    for (NSString *key in keys) {
        id candidate = TRSafeValueForKey(player, l(key));
        if ([candidate isKindOfClass:[AVPlayer class]]) {
            return candidate;
        }
    }
    return nil;
}

static void TRCollectPlayerLayers(CALayer *layer, NSMutableArray *playerLayers) {
    if ([layer isKindOfClass:[AVPlayerLayer class]]) {
        [playerLayers addObject:layer];
    }
    for (CALayer *sublayer in [layer sublayers]) {
        TRCollectPlayerLayers(sublayer, playerLayers);
    }
}

static NSArray *TRPlayerLayers(UIView *view) {
    NSMutableArray *playerLayers = [NSMutableArray array];
    if (view) {
        TRCollectPlayerLayers(view.layer, playerLayers);
    } else {
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            TRCollectPlayerLayers(window.layer, playerLayers);
        }
    }
    return playerLayers;
}

// players detached from their layers while in the background
static NSMutableArray *gTRDetachedLayers = nil;
static NSMutableArray *gTRDetachedPlayers = nil;

NSArray *TRVisibleAVPlayers(UIView *view) {
    NSMutableArray *players = [NSMutableArray array];
    for (AVPlayerLayer *playerLayer in TRPlayerLayers(view)) {
        AVPlayer *player = playerLayer.player;
        if (player && ![players containsObject:player]) {
            [players addObject:player];
        }
    }
    if (!view) {
        for (AVPlayer *player in gTRDetachedPlayers) {
            if (![players containsObject:player]) {
                [players addObject:player];
            }
        }
    }
    return players;
}

static AVPlayer *TRBestAVPlayer(id controller, UIView *view) {
    AVPlayer *avPlayer = TRAVPlayerOfPlayer(TRPlayerOfController(controller));
    if (avPlayer) return avPlayer;
    NSArray *players = TRVisibleAVPlayers(view);
    for (AVPlayer *player in players) {
        if ([player rate] > 0) return player;
    }
    return [players count] > 0 ? [players objectAtIndex:0] : nil;
}

static double TRClampSeekTarget(double target, double total) {
    if (target < 0 || isnan(target)) target = 0;
    // stop just short of the end, so seeking forward never "finishes" the video by accident
    if (total > 1 && !isnan(total) && target > total - 1) target = total - 1;
    return target;
}

double TRPlaybackCurrentTime(id controller) {
    id player = TRPlayerOfController(controller);
    double time = TRPlayerCurrentTime(player);
    if (time <= 0) {
        AVPlayer *avPlayer = TRBestAVPlayer(controller, nil);
        if (avPlayer) {
            time = CMTimeGetSeconds([avPlayer currentTime]);
        }
    }
    return isnan(time) ? 0 : time;
}

double TRPlaybackDuration(id controller) {
    double duration = TRPlayerTotalTime(TRPlayerOfController(controller));
    if (duration <= 0 || isnan(duration)) {
        AVPlayer *avPlayer = TRBestAVPlayer(controller, nil);
        if ([avPlayer currentItem]) {
            duration = CMTimeGetSeconds([[avPlayer currentItem] duration]);
        }
    }
    return (isnan(duration) || duration < 0) ? 0 : duration;
}

BOOL TRSeekPlaybackBy(id controller, UIView *view, double delta) {
    id player = TRPlayerOfController(controller);
    if (player && ![player isKindOfClass:[AVPlayer class]] && [player respondsToSelector:@selector(seekToTime:)]) {
        double target = TRClampSeekTarget(TRPlayerCurrentTime(player) + delta, TRPlayerTotalTime(player));
        // what the app's own scrubber does (-[YTPlayerController
        // didSeekToTime:]): seekToTime: leaves MLPlayer paused, so resume
        // it if it was playing
        BOOL wasPlaying = TRPlaybackIsPlaying(controller);
        [(id<TFLPlaybackMessages>)player seekToTime:target];
        if (wasPlaying && [player respondsToSelector:@selector(play)]) {
            [(id<TFLPlaybackMessages>)player play];
        }
        return YES;
    }

    AVPlayer *avPlayer = TRBestAVPlayer(controller, view);
    if (!avPlayer) {
        return NO;
    }
    double current = CMTimeGetSeconds([avPlayer currentTime]);
    double total = [avPlayer currentItem] ? CMTimeGetSeconds([[avPlayer currentItem] duration]) : 0;
    double target = TRClampSeekTarget(current + delta, total);
    [avPlayer seekToTime:CMTimeMakeWithSeconds(target, 600)];
    return YES;
}

BOOL TRPlaybackIsPlaying(id controller) {
    id player = TRPlayerOfController(controller);
    if ([player respondsToSelector:@selector(isPlaying)]) {
        return [(id<TFLPlaybackMessages>)player isPlaying];
    }
    AVPlayer *avPlayer = TRBestAVPlayer(controller, nil);
    return avPlayer && [avPlayer rate] > 0;
}

BOOL TRPlaybackPlay(id controller) {
    if ([controller respondsToSelector:@selector(didPressPlay)]) {
        [(id<TFLPlaybackMessages>)controller didPressPlay];
        return YES;
    }
    AVPlayer *avPlayer = TRBestAVPlayer(controller, nil);
    [avPlayer play];
    return avPlayer != nil;
}

BOOL TRPlaybackPause(id controller) {
    if ([controller respondsToSelector:@selector(didPressPause)]) {
        [(id<TFLPlaybackMessages>)controller didPressPause];
        return YES;
    }
    AVPlayer *avPlayer = TRBestAVPlayer(controller, nil);
    [avPlayer pause];
    return avPlayer != nil;
}

#pragma mark - Audio session and the apps' own background switch

static BOOL TRVersionIs10(void) {
    NSString *appVersion = version();
    return [appVersion isEqualToString:@"1.0.0"] || [appVersion isEqualToString:@"1.0.1"];
}

static BOOL TRAppHasAudioBackgroundMode(void) {
    NSArray *modes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    return [modes isKindOfClass:[NSArray class]] && [modes containsObject:@"audio"];
}

// Playback category: keeps playing when locked/backgrounded, and makes the
// app eligible to own the lock screen controls.
static void TREnsurePlaybackAudioSession(void) {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (![[session category] isEqualToString:AVAudioSessionCategoryPlayback]) {
        NSError *error = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
            NSLog(@"[TubeFixLegacy] couldn't switch the audio session to playback: %@", error);
        }
    }
    [session setActive:YES error:NULL];
}

static void TRAllowBackgroundOn(id object) {
    if (!object) return;
    if ([object respondsToSelector:@selector(setBackgroundPlaybackAllowed:)]) {
        [(id<TFLPlaybackMessages>)object setBackgroundPlaybackAllowed:YES];
    }
    if ([object respondsToSelector:@selector(setHiddenPlaybackAllowed:)]) {
        [(id<TFLPlaybackMessages>)object setHiddenPlaybackAllowed:YES];
    }
}

// Sets the app's own "keep playing in the background" flags on the
// controller and its player (1.1.0+). Must run before the app checks them
// in -appWillResignActive / -appDidEnterBackground.
static void TRAllowBackgroundPlayback(id controller) {
    if (!controller || !TRBackgroundPlaybackEnabled()) {
        return;
    }
    TRAllowBackgroundOn(controller);
    TRAllowBackgroundOn(TRPlayerOfController(controller));
}

#pragma mark - Now playing info (lock screen / multitasking bar)

static NSMutableDictionary *gTRArtworkCache = nil;   // video ID -> MPMediaItemArtwork
static NSMutableSet *gTRArtworkLoading = nil;

static id TRVideoOfController(id controller) {
    if ([controller respondsToSelector:@selector(videoOrAdVideo)]) {
        id video = [(id<TFLPlaybackMessages>)controller videoOrAdVideo];
        if (video) return video;
    }
    if ([controller respondsToSelector:@selector(video)]) {
        id video = [(id<TFLPlaybackMessages>)controller video];
        if (video) return video;
    }
    return TRSafeValueForKey(controller, l(@"video"));
}

static NSString *TRVideoID(id video) {
    id videoID = [video respondsToSelector:@selector(ID)] ? [(id<TFLPlaybackMessages>)video ID] : nil;
    return [videoID isKindOfClass:[NSString class]] ? videoID : nil;
}

// thumbnailURLs maps NSValue(CGSize) -> NSURL; take the biggest up to 480px wide
static NSURL *TRArtworkURLForVideo(id video) {
    NSDictionary *thumbnails = [video respondsToSelector:@selector(thumbnailURLs)] ? [(id<TFLPlaybackMessages>)video thumbnailURLs] : nil;
    NSURL *best = nil;
    CGFloat bestWidth = 0;
    if ([thumbnails isKindOfClass:[NSDictionary class]]) {
        for (id key in thumbnails) {
            id value = [thumbnails objectForKey:key];
            NSURL *url = [value isKindOfClass:[NSURL class]] ? value : ([value isKindOfClass:[NSString class]] ? [NSURL URLWithString:value] : nil);
            CGFloat width = 1;
            if ([key isKindOfClass:[NSValue class]] && strcmp([key objCType], @encode(CGSize)) == 0) {
                width = [key CGSizeValue].width;
            }
            if (url && width <= 480 && width > bestWidth) {
                best = url;
                bestWidth = width;
            }
        }
    }
    NSString *videoID = TRVideoID(video);
    if (!best && videoID) {
        best = [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/hqdefault.jpg", videoID]];
    }
    return best;
}

static void TRUpdateNowPlayingInfo(id controller, BOOL playing);

static void TRLoadArtwork(id controller, id video) {
    NSString *videoID = TRVideoID(video);
    NSURL *url = TRArtworkURLForVideo(video);
    if (!videoID || !url || [gTRArtworkCache objectForKey:videoID] || [gTRArtworkLoading containsObject:videoID]) {
        return;
    }
    [gTRArtworkLoading addObject:videoID];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [gTRArtworkLoading removeObject:videoID];
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if (!image) {
            return;
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [gTRArtworkCache setObject:artwork forKey:videoID];
        [artwork release];
        // still the same video? then show it
        id active = TRActivePlayerController();
        if (active && [TRVideoID(TRVideoOfController(active)) isEqualToString:videoID]) {
            TRUpdateNowPlayingInfo(active, TRPlaybackIsPlaying(active));
        }
    }];
}

static void TRUpdateNowPlayingInfo(id controller, BOOL playing) {
    if (!TRLockScreenControlsEnabled() || !controller) {
        return;
    }
    id video = TRVideoOfController(controller);
    if (!video) {
        return;
    }

    double elapsed = TRPlaybackCurrentTime(controller);
    double duration = TRPlaybackDuration(controller);
    if (duration <= 0 && [video respondsToSelector:@selector(duration)]) {
        duration = [(id<TFLPlaybackMessages>)video duration];
    }

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    NSString *title = [video respondsToSelector:@selector(title)] ? [(id<TFLPlaybackMessages>)video title] : nil;
    if ([title isKindOfClass:[NSString class]]) {
        [info setObject:title forKey:MPMediaItemPropertyTitle];
    }
    NSString *uploader = [video respondsToSelector:@selector(uploaderDisplayName)] ? [(id<TFLPlaybackMessages>)video uploaderDisplayName] : nil;
    if ([uploader isKindOfClass:[NSString class]]) {
        [info setObject:uploader forKey:MPMediaItemPropertyArtist];
    }
    [info setObject:@"YouTube" forKey:MPMediaItemPropertyAlbumTitle];
    [info setObject:[NSNumber numberWithDouble:duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [info setObject:[NSNumber numberWithDouble:elapsed] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [info setObject:[NSNumber numberWithDouble:(playing ? 1.0 : 0.0)] forKey:MPNowPlayingInfoPropertyPlaybackRate];

    NSString *videoID = TRVideoID(video);
    MPMediaItemArtwork *artwork = videoID ? [gTRArtworkCache objectForKey:videoID] : nil;
    if (artwork) {
        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    } else {
        TRLoadArtwork(controller, video);
    }

    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    TFLLog(@"now playing: %@ - %@ (%.0f/%.0f s, %@)", [info objectForKey:MPMediaItemPropertyTitle], [info objectForKey:MPMediaItemPropertyArtist], elapsed, duration, playing ? @"playing" : @"paused");
}

static void TRClearNowPlayingInfo(void) {
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}

#pragma mark - Play / pause / finish

static void TRPlaybackDidStart(id controller) {
    TRSetActivePlayerController(controller);
    TRAllowBackgroundPlayback(controller);
    if (TRBackgroundPlaybackEnabled() || TRLockScreenControlsEnabled()) {
        TREnsurePlaybackAudioSession();
    }
    if (TRLockScreenControlsEnabled()) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    TRUpdateNowPlayingInfo(controller, YES);
    id player = TRPlayerOfController(controller);
    TFLLog(@"playing \"%@\": controller %@, player %@, AVPlayer %@, audio %@, bg flags %@/%@",
           [TRVideoOfController(controller) title], NSStringFromClass([controller class]), NSStringFromClass([player class]),
           TRAVPlayerOfPlayer(player), [[AVAudioSession sharedInstance] category],
           TRSafeValueForKey(controller, l(@"backgroundPlaybackAllowed")), TRSafeValueForKey(player, l(@"backgroundPlaybackAllowed")));
}

static void TRPlaybackDidPause(id controller) {
    TFLLog(@"paused (%@, active %d, app state %d)", NSStringFromClass([controller class]), TRActivePlayerController() == controller, (int)[[UIApplication sharedApplication] applicationState]);
    if (TRActivePlayerController() == controller) {
        TRUpdateNowPlayingInfo(controller, NO);
    }
}

static void TRPlaybackDidFinish(id controller) {
    if (TRActivePlayerController() == controller) {
        TRUpdateNowPlayingInfo(controller, NO);
    }
}

static void TRPlayerControllerWillGoAway(id controller) {
    if (TRActivePlayerController() == controller) {
        TRClearActivePlayerController(controller);
        TRClearNowPlayingInfo();
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
}

#pragma mark - Remote control (lock screen, headphones, multitasking bar)

static BOOL TRHandleRemoteControlEvent(UIEvent *event) {
    if ([event type] != UIEventTypeRemoteControl || !TRLockScreenControlsEnabled()) {
        return NO;
    }
    id controller = TRActivePlayerController();
    TFLLog(@"remote control event %d, controller %@", (int)[event subtype], controller);
    if (!controller && [TRVisibleAVPlayers(nil) count] == 0) {
        return NO;
    }

    switch ([event subtype]) {
        case UIEventSubtypeRemoteControlPlay:
            TRPlaybackPlay(controller);
            break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop:
            TRPlaybackPause(controller);
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (TRPlaybackIsPlaying(controller)) {
                TRPlaybackPause(controller);
            } else {
                TRPlaybackPlay(controller);
            }
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            TRSeekPlaybackBy(controller, nil, TRDoubleTapSeekSeconds());
            TRUpdateNowPlayingInfo(controller, TRPlaybackIsPlaying(controller));
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            TRSeekPlaybackBy(controller, nil, -TRDoubleTapSeekSeconds());
            TRUpdateNowPlayingInfo(controller, TRPlaybackIsPlaying(controller));
            break;
        default:
            return NO;
    }
    return YES;
}

%hook UIApplication

- (void)sendEvent:(UIEvent *)event
{
    if ([event type] == UIEventTypeRemoteControl && TRHandleRemoteControlEvent(event)) {
        return;
    }
    %orig;
}

// in case the event arrives through the responder chain instead
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (TRHandleRemoteControlEvent(event)) {
        return;
    }
    %orig;
}

%end

#pragma mark - Keeping playback alive in the background

static NSMutableSet *gTRPlayersPlayingAtResign = nil;
static BOOL gTRWasPlayingAtResign = NO;
static BOOL gTRAudioInterrupted = NO;
static UIBackgroundTaskIdentifier gTRBackgroundTask; // UIBackgroundTaskInvalid, set in the ctor

static void TREndBackgroundTask(void) {
    if (gTRBackgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:gTRBackgroundTask];
        gTRBackgroundTask = UIBackgroundTaskInvalid;
    }
}

static void TRAppWillResignActive(void) {
    [gTRPlayersPlayingAtResign removeAllObjects];
    gTRWasPlayingAtResign = NO;
    if (!TRBackgroundPlaybackEnabled()) {
        return;
    }
    id controller = TRActivePlayerController();
    TRAllowBackgroundPlayback(controller);
    for (AVPlayer *player in TRVisibleAVPlayers(nil)) {
        if ([player rate] > 0) {
            [gTRPlayersPlayingAtResign addObject:player];
        }
    }
    if (controller && TRPlaybackIsPlaying(controller)) {
        gTRWasPlayingAtResign = YES;
        AVPlayer *avPlayer = TRAVPlayerOfPlayer(TRPlayerOfController(controller));
        if (avPlayer) {
            [gTRPlayersPlayingAtResign addObject:avPlayer];
        }
    }
    if ([gTRPlayersPlayingAtResign count] > 0) {
        gTRWasPlayingAtResign = YES;
        TREnsurePlaybackAudioSession();
    }
    TFLLog(@"resign active: controller %@, playing players %u, was playing %d", controller, (unsigned)[gTRPlayersPlayingAtResign count], gTRWasPlayingAtResign);
}

static void TRBeginBackgroundTask(void) {
    if (gTRBackgroundTask == UIBackgroundTaskInvalid) {
        gTRBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            TREndBackgroundTask();
        }];
    }
}

static void TRAppDidEnterBackground(void) {
    TFLLog(@"entered background: enabled %d, interrupted %d, was playing %d, layers %u", TRBackgroundPlaybackEnabled(), gTRAudioInterrupted, gTRWasPlayingAtResign, (unsigned)[TRPlayerLayers(nil) count]);
    if (!TRBackgroundPlaybackEnabled() || gTRAudioInterrupted || !gTRWasPlayingAtResign) {
        return;
    }

    // iOS pauses an AVPlayer that is attached to a layer on screen when the
    // app goes to the background (Technical Q&A QA1668). 1.1.0+ detach it
    // themselves once their flag is set; 1.0.x never does. Detaching here as
    // well is harmless - the app just finds the layer already empty.
    for (AVPlayerLayer *playerLayer in TRPlayerLayers(nil)) {
        AVPlayer *player = playerLayer.player;
        if (!player || ![gTRPlayersPlayingAtResign containsObject:player]) {
            continue;
        }
        // AirPlay video keeps going without our help (airPlayVideoActive is
        // iOS 5/6 API that newer SDKs no longer declare)
        SEL airPlayActiveSelector = NSSelectorFromString(@"isAirPlayVideoActive");
        if ([player respondsToSelector:airPlayActiveSelector] && ((BOOL (*)(id, SEL))objc_msgSend)(player, airPlayActiveSelector)) {
            continue;
        }
        [gTRDetachedLayers addObject:playerLayer];
        [gTRDetachedPlayers addObject:player];
        playerLayer.player = nil;
    }

    if (!TRAppHasAudioBackgroundMode()) {
        // 1.0.x and 1.1.0 don't declare the audio background mode, so iOS
        // would suspend them right away; a background task buys up to ten
        // minutes of playback there. 1.2.1+ can play indefinitely.
        TRBeginBackgroundTask();
    }

    // if anything paused the video on the way out, start it again
    NSArray *toResume = [[gTRPlayersPlayingAtResign allObjects] retain];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground && !gTRAudioInterrupted) {
            id controller = TRActivePlayerController();
            AVPlayer *controllerPlayer = TRAVPlayerOfPlayer(TRPlayerOfController(controller));
            BOOL resumed = NO;
            for (AVPlayer *player in toResume) {
                if ([player rate] > 0) {
                    continue;
                }
                if (player == controllerPlayer && !resumed) {
                    TRPlaybackPlay(controller);
                    resumed = YES;
                } else {
                    [player play];
                }
            }
            if (resumed || [toResume count] > 0) {
                TRUpdateNowPlayingInfo(controller, YES);
            }
        }
        for (AVPlayer *player in toResume) {
            TFLLog(@"after background: %@ rate %.1f, app state %d", player, [player rate], (int)[[UIApplication sharedApplication] applicationState]);
        }
        [toResume release];
    });
}

static void TRAppWillEnterForeground(void) {
    for (NSUInteger i = 0; i < [gTRDetachedLayers count]; i++) {
        AVPlayerLayer *playerLayer = [gTRDetachedLayers objectAtIndex:i];
        if (!playerLayer.player) {
            playerLayer.player = [gTRDetachedPlayers objectAtIndex:i];
        }
    }
    [gTRDetachedLayers removeAllObjects];
    [gTRDetachedPlayers removeAllObjects];
    [gTRPlayersPlayingAtResign removeAllObjects];
    gTRWasPlayingAtResign = NO;
    TREndBackgroundTask();
}

static void TRAudioSessionInterruption(NSNotification *notification) {
    // AVAudioSessionInterruptionTypeKey: 1 = began, 0 = ended (iOS 6+)
    NSNumber *type = [[notification userInfo] objectForKey:@"AVAudioSessionInterruptionTypeKey"];
    if (type) {
        gTRAudioInterrupted = ([type unsignedIntegerValue] == 1);
    }
}

#pragma mark - Hooks: 1.0.x - 1.4.0

%hook YTPlayerController

// 1.0.x
- (void)playbackDidPlay
{
    %orig;
    TRPlaybackDidStart(self);
}

- (void)playbackDidPause
{
    %orig;
    TRPlaybackDidPause(self);
}

- (void)playbackDidFinish
{
    %orig;
    TRPlaybackDidFinish(self);
}

// 1.1.0 - 1.4.0
- (void)playerStateDidChangeToPlaying
{
    %orig;
    TRPlaybackDidStart(self);
}

- (void)playerStateDidChangeToPaused
{
    %orig;
    TRPlaybackDidPause(self);
}

- (void)playerStateDidChangeToFinished
{
    %orig;
    TRPlaybackDidFinish(self);
}

- (void)didSeekToTime:(double)time
{
    %orig;
    if (TRActivePlayerController() == self) {
        TRUpdateNowPlayingInfo(self, TRPlaybackIsPlaying(self));
    }
}

// 1.1.0+ pause here unless backgroundPlaybackAllowed_ is set; 1.0.x
// always calls pauseAndReleasePlayer here, which tears the player down.
- (void)appWillResignActive
{
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundPlayback(self);
        if (TRVersionIs10() && TRPlaybackIsPlaying(self)) {
            return;
        }
    }
    %orig;
}

- (void)dealloc
{
    TRPlayerControllerWillGoAway(self);
    %orig;
}

%end

// YTPlayer (1.1.0 - 1.3.0) and MLPlayer (1.4.0) read their ivar in
// -appDidEnterBackground; make sure it is set right before.
%hook YTPlayer

- (BOOL)backgroundPlaybackAllowed
{
    return TRBackgroundPlaybackEnabled() ? YES : %orig;
}

- (void)appDidEnterBackground
{
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundOn(self);
    }
    %orig;
}

%end

%hook MLPlayer

- (BOOL)backgroundPlaybackAllowed
{
    return TRBackgroundPlaybackEnabled() ? YES : %orig;
}

// 2.x name of the same flag, asked for by YTPlayerViewController
- (BOOL)hiddenPlaybackAllowed
{
    return TRBackgroundPlaybackEnabled() ? YES : %orig;
}

- (void)appDidEnterBackground
{
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundOn(self);
    }
    %orig;
}

%end

#pragma mark - Hooks: 2.x

%hook YTPlayerViewController

- (void)playerStateDidChangeToPlaying
{
    %orig;
    TRPlaybackDidStart(self);
}

- (void)playerStateDidChangeToPaused
{
    %orig;
    TRPlaybackDidPause(self);
}

- (void)playerStateDidChangeToFinished
{
    %orig;
    TRPlaybackDidFinish(self);
}

- (void)didSeekToTime:(double)time
{
    %orig;
    if (TRActivePlayerController() == self) {
        TRUpdateNowPlayingInfo(self, TRPlaybackIsPlaying(self));
    }
}

- (void)appWillResignActive
{
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundPlayback(self);
    }
    %orig;
}

- (void)dealloc
{
    TRPlayerControllerWillGoAway(self);
    %orig;
}

%end

%ctor {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }

    gTRBackgroundTask = UIBackgroundTaskInvalid;
    gTRDetachedLayers = [[NSMutableArray alloc] init];
    gTRDetachedPlayers = [[NSMutableArray alloc] init];
    gTRPlayersPlayingAtResign = [[NSMutableSet alloc] init];
    gTRArtworkCache = [[NSMutableDictionary alloc] init];
    gTRArtworkLoading = [[NSMutableSet alloc] init];

    // queue:nil -> delivered synchronously on the posting (main) thread,
    // and these observers are registered before the app's own, so they run
    // first: the players are remembered before the app pauses them
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TRAppWillResignActive();
    }];
    [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TRAppDidEnterBackground();
    }];
    [center addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TRAppWillEnterForeground();
    }];
    [center addObserverForName:@"AVAudioSessionInterruptionNotification" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TRAudioSessionInterruption(notification);
    }];

    %init;
    TFLLog(@"playback hooks for YouTube %@: YTPlayerController %d, YTPlayer %d, MLPlayer %d, YTPlayerViewController %d, audio modes %@, session %@",
           version(), %c(YTPlayerController) != nil, %c(YTPlayer) != nil, %c(MLPlayer) != nil, %c(YTPlayerViewController) != nil,
           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"], [[AVAudioSession sharedInstance] category]);
}
