#line 1 "googleapp/playback.x"

































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

static id gTRActivePlayerController = nil; 

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




static void TRAllowBackgroundPlayback(id controller) {
    if (!controller || !TRBackgroundPlaybackEnabled()) {
        return;
    }
    TRAllowBackgroundOn(controller);
    TRAllowBackgroundOn(TRPlayerOfController(controller));
}

#pragma mark - Now playing info (lock screen / multitasking bar)

static NSMutableDictionary *gTRArtworkCache = nil;   
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

@class UIApplication; @class YTPlayer; @class YTPlayerController; @class YTPlayerViewController; @class MLPlayer; 
static void (*_logos_orig$_ungrouped$UIApplication$sendEvent$)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void _logos_method$_ungrouped$UIApplication$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void (*_logos_orig$_ungrouped$UIApplication$remoteControlReceivedWithEvent$)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void _logos_method$_ungrouped$UIApplication$remoteControlReceivedWithEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void (*_logos_orig$_ungrouped$YTPlayerController$playbackDidPlay)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playbackDidPlay(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$playbackDidPause)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playbackDidPause(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$playbackDidFinish)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playbackDidFinish(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPaused)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPaused(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToFinished)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToFinished(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$didSeekToTime$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$_ungrouped$YTPlayerController$didSeekToTime$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, double); static void (*_logos_orig$_ungrouped$YTPlayerController$appWillResignActive)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$appWillResignActive(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$YTPlayer$backgroundPlaybackAllowed)(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$YTPlayer$backgroundPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayer$appDidEnterBackground)(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayer$appDidEnterBackground(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$MLPlayer$backgroundPlaybackAllowed)(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$MLPlayer$backgroundPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$MLPlayer$hiddenPlaybackAllowed)(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$MLPlayer$hiddenPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MLPlayer$appDidEnterBackground)(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MLPlayer$appDidEnterBackground(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerViewController$didSeekToTime$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$_ungrouped$YTPlayerViewController$didSeekToTime$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL, double); static void (*_logos_orig$_ungrouped$YTPlayerViewController$appWillResignActive)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerViewController$appWillResignActive(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerViewController$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MLPlayer(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MLPlayer"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTPlayerViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTPlayerViewController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTPlayerController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTPlayerController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTPlayer(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTPlayer"); } return _klass; }
#line 495 "googleapp/playback.x"



static void _logos_method$_ungrouped$UIApplication$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEvent * event) {
    if ([event type] == UIEventTypeRemoteControl && TRHandleRemoteControlEvent(event)) {
        return;
    }
    _logos_orig$_ungrouped$UIApplication$sendEvent$(self, _cmd, event);
}



static void _logos_method$_ungrouped$UIApplication$remoteControlReceivedWithEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEvent * event) {
    if (TRHandleRemoteControlEvent(event)) {
        return;
    }
    _logos_orig$_ungrouped$UIApplication$remoteControlReceivedWithEvent$(self, _cmd, event);
}



#pragma mark - Keeping playback alive in the background

static NSMutableSet *gTRPlayersPlayingAtResign = nil;
static BOOL gTRWasPlayingAtResign = NO;
static BOOL gTRAudioInterrupted = NO;
static UIBackgroundTaskIdentifier gTRBackgroundTask; 

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

    
    
    
    
    for (AVPlayerLayer *playerLayer in TRPlayerLayers(nil)) {
        AVPlayer *player = playerLayer.player;
        if (!player || ![gTRPlayersPlayingAtResign containsObject:player]) {
            continue;
        }
        
        
        SEL airPlayActiveSelector = NSSelectorFromString(@"isAirPlayVideoActive");
        if ([player respondsToSelector:airPlayActiveSelector] && ((BOOL (*)(id, SEL))objc_msgSend)(player, airPlayActiveSelector)) {
            continue;
        }
        [gTRDetachedLayers addObject:playerLayer];
        [gTRDetachedPlayers addObject:player];
        playerLayer.player = nil;
    }

    if (!TRAppHasAudioBackgroundMode()) {
        
        
        
        TRBeginBackgroundTask();
    }

    
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
    
    NSNumber *type = [[notification userInfo] objectForKey:@"AVAudioSessionInterruptionTypeKey"];
    if (type) {
        gTRAudioInterrupted = ([type unsignedIntegerValue] == 1);
    }
}

#pragma mark - Hooks: 1.0.x - 1.4.0





static void _logos_method$_ungrouped$YTPlayerController$playbackDidPlay(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playbackDidPlay(self, _cmd);
    TRPlaybackDidStart(self);
}


static void _logos_method$_ungrouped$YTPlayerController$playbackDidPause(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playbackDidPause(self, _cmd);
    TRPlaybackDidPause(self);
}


static void _logos_method$_ungrouped$YTPlayerController$playbackDidFinish(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playbackDidFinish(self, _cmd);
    TRPlaybackDidFinish(self);
}



static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying(self, _cmd);
    TRPlaybackDidStart(self);
}


static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPaused(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPaused(self, _cmd);
    TRPlaybackDidPause(self);
}


static void _logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToFinished(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToFinished(self, _cmd);
    TRPlaybackDidFinish(self);
}


static void _logos_method$_ungrouped$YTPlayerController$didSeekToTime$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double time) {
    _logos_orig$_ungrouped$YTPlayerController$didSeekToTime$(self, _cmd, time);
    if (TRActivePlayerController() == self) {
        TRUpdateNowPlayingInfo(self, TRPlaybackIsPlaying(self));
    }
}




static void _logos_method$_ungrouped$YTPlayerController$appWillResignActive(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundPlayback(self);
        if (TRVersionIs10() && TRPlaybackIsPlaying(self)) {
            return;
        }
    }
    _logos_orig$_ungrouped$YTPlayerController$appWillResignActive(self, _cmd);
}


static void _logos_method$_ungrouped$YTPlayerController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    TRPlayerControllerWillGoAway(self);
    _logos_orig$_ungrouped$YTPlayerController$dealloc(self, _cmd);
}








static BOOL _logos_method$_ungrouped$YTPlayer$backgroundPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return TRBackgroundPlaybackEnabled() ? YES : _logos_orig$_ungrouped$YTPlayer$backgroundPlaybackAllowed(self, _cmd);
}


static void _logos_method$_ungrouped$YTPlayer$appDidEnterBackground(_LOGOS_SELF_TYPE_NORMAL YTPlayer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundOn(self);
    }
    _logos_orig$_ungrouped$YTPlayer$appDidEnterBackground(self, _cmd);
}






static BOOL _logos_method$_ungrouped$MLPlayer$backgroundPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return TRBackgroundPlaybackEnabled() ? YES : _logos_orig$_ungrouped$MLPlayer$backgroundPlaybackAllowed(self, _cmd);
}



static BOOL _logos_method$_ungrouped$MLPlayer$hiddenPlaybackAllowed(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return TRBackgroundPlaybackEnabled() ? YES : _logos_orig$_ungrouped$MLPlayer$hiddenPlaybackAllowed(self, _cmd);
}


static void _logos_method$_ungrouped$MLPlayer$appDidEnterBackground(_LOGOS_SELF_TYPE_NORMAL MLPlayer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundOn(self);
    }
    _logos_orig$_ungrouped$MLPlayer$appDidEnterBackground(self, _cmd);
}



#pragma mark - Hooks: 2.x




static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying(self, _cmd);
    TRPlaybackDidStart(self);
}


static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused(self, _cmd);
    TRPlaybackDidPause(self);
}


static void _logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished(self, _cmd);
    TRPlaybackDidFinish(self);
}


static void _logos_method$_ungrouped$YTPlayerViewController$didSeekToTime$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double time) {
    _logos_orig$_ungrouped$YTPlayerViewController$didSeekToTime$(self, _cmd, time);
    if (TRActivePlayerController() == self) {
        TRUpdateNowPlayingInfo(self, TRPlaybackIsPlaying(self));
    }
}


static void _logos_method$_ungrouped$YTPlayerViewController$appWillResignActive(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (TRBackgroundPlaybackEnabled()) {
        TRAllowBackgroundPlayback(self);
    }
    _logos_orig$_ungrouped$YTPlayerViewController$appWillResignActive(self, _cmd);
}


static void _logos_method$_ungrouped$YTPlayerViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    TRPlayerControllerWillGoAway(self);
    _logos_orig$_ungrouped$YTPlayerViewController$dealloc(self, _cmd);
}



static __attribute__((constructor)) void _logosLocalCtor_cb4cd44b(int __unused argc, char __unused **argv, char __unused **envp) {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }

    gTRBackgroundTask = UIBackgroundTaskInvalid;
    gTRDetachedLayers = [[NSMutableArray alloc] init];
    gTRDetachedPlayers = [[NSMutableArray alloc] init];
    gTRPlayersPlayingAtResign = [[NSMutableSet alloc] init];
    gTRArtworkCache = [[NSMutableDictionary alloc] init];
    gTRArtworkLoading = [[NSMutableSet alloc] init];

    
    
    
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

    {Class _logos_class$_ungrouped$UIApplication = objc_getClass("UIApplication"); { MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(sendEvent:), (IMP)&_logos_method$_ungrouped$UIApplication$sendEvent$, (IMP*)&_logos_orig$_ungrouped$UIApplication$sendEvent$);}{ MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(remoteControlReceivedWithEvent:), (IMP)&_logos_method$_ungrouped$UIApplication$remoteControlReceivedWithEvent$, (IMP*)&_logos_orig$_ungrouped$UIApplication$remoteControlReceivedWithEvent$);}Class _logos_class$_ungrouped$YTPlayerController = objc_getClass("YTPlayerController"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playbackDidPlay), (IMP)&_logos_method$_ungrouped$YTPlayerController$playbackDidPlay, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playbackDidPlay);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playbackDidPause), (IMP)&_logos_method$_ungrouped$YTPlayerController$playbackDidPause, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playbackDidPause);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playbackDidFinish), (IMP)&_logos_method$_ungrouped$YTPlayerController$playbackDidFinish, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playbackDidFinish);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playerStateDidChangeToPlaying), (IMP)&_logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPlaying);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playerStateDidChangeToPaused), (IMP)&_logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToPaused, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToPaused);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(playerStateDidChangeToFinished), (IMP)&_logos_method$_ungrouped$YTPlayerController$playerStateDidChangeToFinished, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$playerStateDidChangeToFinished);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(didSeekToTime:), (IMP)&_logos_method$_ungrouped$YTPlayerController$didSeekToTime$, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$didSeekToTime$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(appWillResignActive), (IMP)&_logos_method$_ungrouped$YTPlayerController$appWillResignActive, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$appWillResignActive);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$YTPlayerController$dealloc, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$dealloc);}Class _logos_class$_ungrouped$YTPlayer = objc_getClass("YTPlayer"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayer, @selector(backgroundPlaybackAllowed), (IMP)&_logos_method$_ungrouped$YTPlayer$backgroundPlaybackAllowed, (IMP*)&_logos_orig$_ungrouped$YTPlayer$backgroundPlaybackAllowed);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayer, @selector(appDidEnterBackground), (IMP)&_logos_method$_ungrouped$YTPlayer$appDidEnterBackground, (IMP*)&_logos_orig$_ungrouped$YTPlayer$appDidEnterBackground);}Class _logos_class$_ungrouped$MLPlayer = objc_getClass("MLPlayer"); { MSHookMessageEx(_logos_class$_ungrouped$MLPlayer, @selector(backgroundPlaybackAllowed), (IMP)&_logos_method$_ungrouped$MLPlayer$backgroundPlaybackAllowed, (IMP*)&_logos_orig$_ungrouped$MLPlayer$backgroundPlaybackAllowed);}{ MSHookMessageEx(_logos_class$_ungrouped$MLPlayer, @selector(hiddenPlaybackAllowed), (IMP)&_logos_method$_ungrouped$MLPlayer$hiddenPlaybackAllowed, (IMP*)&_logos_orig$_ungrouped$MLPlayer$hiddenPlaybackAllowed);}{ MSHookMessageEx(_logos_class$_ungrouped$MLPlayer, @selector(appDidEnterBackground), (IMP)&_logos_method$_ungrouped$MLPlayer$appDidEnterBackground, (IMP*)&_logos_orig$_ungrouped$MLPlayer$appDidEnterBackground);}Class _logos_class$_ungrouped$YTPlayerViewController = objc_getClass("YTPlayerViewController"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(playerStateDidChangeToPlaying), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPlaying);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(playerStateDidChangeToPaused), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToPaused);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(playerStateDidChangeToFinished), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$playerStateDidChangeToFinished);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(didSeekToTime:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$didSeekToTime$, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$didSeekToTime$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(appWillResignActive), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$appWillResignActive, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$appWillResignActive);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$dealloc, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$dealloc);}}
    TFLLog(@"playback hooks for YouTube %@: YTPlayerController %d, YTPlayer %d, MLPlayer %d, YTPlayerViewController %d, audio modes %@, session %@",
           version(), _logos_static_class_lookup$YTPlayerController() != nil, _logos_static_class_lookup$YTPlayer() != nil, _logos_static_class_lookup$MLPlayer() != nil, _logos_static_class_lookup$YTPlayerViewController() != nil,
           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"], [[AVAudioSession sharedInstance] category]);
}
