#line 1 "classic/classic.x"































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
static NSString *gTFLServerBase = nil;   
static NSString *gTFLServiceHost = nil;  
static NSString *gTFLAPIKey = nil;
static NSString *gTFLAPIKeyHeader = nil;

static NSString *TFLNormalizedServerBase(id rawValue) {
    NSString *base = [rawValue isKindOfClass:[NSString class]] ? [rawValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : nil;
    if ([base length] == 0) {
        base = TFL_DEFAULT_SERVER;
    }
    
    if ([base rangeOfString:@"://"].location == NSNotFound) {
        base = [@"http://" stringByAppendingString:base];
    }
    while ([base hasSuffix:@"/"]) {
        base = [base substringToIndex:[base length] - 1];
    }
    return base;
}



static NSString *TFLServiceHostFromBase(NSString *base) {
    NSRange scheme = [base rangeOfString:@"://"];
    return (scheme.location == NSNotFound) ? base : [base substringFromIndex:NSMaxRange(scheme)];
}


static NSString *TFLRewrittenURLString(NSString *urlString) {
    if (!gTFLActive || ![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
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
        
        if ([rest length] > 0 && ![rest hasPrefix:@"/"] && ![rest hasPrefix:@"?"] && ![rest hasPrefix:@":"]) {
            return nil;
        }
        if ([rest hasPrefix:@":"]) {
            
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

@class NSMutableURLRequest; @class MPMoviePlayerControllerNew; @class UIApplication; @class NSURLRequest; @class NSURL; @class YTMoviePlayerViewController; @class YTDeviceAuthenticator; @class YTWebServiceConfig; 
static id (*_logos_meta_orig$_ungrouped$NSURL$URLWithString$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); static id _logos_meta_method$_ungrouped$NSURL$URLWithString$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); static id (*_logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, NSURL *); static id _logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, NSURL *); static NSURL* (*_logos_orig$_ungrouped$NSURL$initWithString$)(_LOGOS_SELF_TYPE_INIT NSURL*, SEL, NSString *) _LOGOS_RETURN_RETAINED; static NSURL* _logos_method$_ungrouped$NSURL$initWithString$(_LOGOS_SELF_TYPE_INIT NSURL*, SEL, NSString *) _LOGOS_RETURN_RETAINED; static NSURL* (*_logos_orig$_ungrouped$NSURL$initWithString$relativeToURL$)(_LOGOS_SELF_TYPE_INIT NSURL*, SEL, NSString *, NSURL *) _LOGOS_RETURN_RETAINED; static NSURL* _logos_method$_ungrouped$NSURL$initWithString$relativeToURL$(_LOGOS_SELF_TYPE_INIT NSURL*, SEL, NSString *, NSURL *) _LOGOS_RETURN_RETAINED; static NSURLRequest* (*_logos_orig$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$)(_LOGOS_SELF_TYPE_INIT NSURLRequest*, SEL, NSURL *, NSURLRequestCachePolicy, NSTimeInterval) _LOGOS_RETURN_RETAINED; static NSURLRequest* _logos_method$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$(_LOGOS_SELF_TYPE_INIT NSURLRequest*, SEL, NSURL *, NSURLRequestCachePolicy, NSTimeInterval) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$NSMutableURLRequest$setURL$)(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSURL *); static void _logos_method$_ungrouped$NSMutableURLRequest$setURL$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSURL *); static void (*_logos_orig$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$)(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); static void _logos_method$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); static void (*_logos_orig$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$)(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); static void _logos_method$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); 

#line 154 "classic/classic.x"



static id _logos_meta_method$_ungrouped$NSURL$URLWithString$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * URLString) {
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return _logos_meta_orig$_ungrouped$NSURL$URLWithString$(self, _cmd, rewritten ?: URLString);
}


static id _logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * URLString, NSURL * baseURL) {
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return _logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$(self, _cmd, rewritten ?: URLString, baseURL);
}


static NSURL* _logos_method$_ungrouped$NSURL$initWithString$(_LOGOS_SELF_TYPE_INIT NSURL* __unused self, SEL __unused _cmd, NSString * URLString) _LOGOS_RETURN_RETAINED {
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return _logos_orig$_ungrouped$NSURL$initWithString$(self, _cmd, rewritten ?: URLString);
}


static NSURL* _logos_method$_ungrouped$NSURL$initWithString$relativeToURL$(_LOGOS_SELF_TYPE_INIT NSURL* __unused self, SEL __unused _cmd, NSString * URLString, NSURL * baseURL) _LOGOS_RETURN_RETAINED {
    NSString *rewritten = TFLRewrittenURLString(URLString);
    if (rewritten) TFLLogRedirect(URLString, rewritten);
    return _logos_orig$_ungrouped$NSURL$initWithString$relativeToURL$(self, _cmd, rewritten ?: URLString, baseURL);
}






static NSURLRequest* _logos_method$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$(_LOGOS_SELF_TYPE_INIT NSURLRequest* __unused self, SEL __unused _cmd, NSURL * URL, NSURLRequestCachePolicy cachePolicy, NSTimeInterval timeoutInterval) _LOGOS_RETURN_RETAINED {
    NSURL *rewritten = TFLRewrittenURL(URL);
    id request = _logos_orig$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$(self, _cmd, rewritten ?: URL, cachePolicy, timeoutInterval);
    TFLAddAPIKeyIfNeeded(request);
    return request;
}






static void _logos_method$_ungrouped$NSMutableURLRequest$setURL$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * URL) {
    NSURL *rewritten = TFLRewrittenURL(URL);
    _logos_orig$_ungrouped$NSMutableURLRequest$setURL$(self, _cmd, rewritten ?: URL);
    TFLAddAPIKeyIfNeeded(self);
}




static void _logos_method$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * value, NSString * field) {
    if (TFLIsGoogleHostHeader(field, value)) {
        return;
    }
    _logos_orig$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$(self, _cmd, value, field);
}


static void _logos_method$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$(_LOGOS_SELF_TYPE_NORMAL NSMutableURLRequest* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * value, NSString * field) {
    if (TFLIsGoogleHostHeader(field, value)) {
        return;
    }
    _logos_orig$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$(self, _cmd, value, field);
}



#pragma mark - YouTube.framework (Classic)

static void (*_logos_meta_orig$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSMutableURLRequest *, BOOL); static void _logos_meta_method$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSMutableURLRequest *, BOOL); static void (*_logos_orig$ClassicFramework$YTDeviceAuthenticator$authenticate)(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST, SEL); static void _logos_method$ClassicFramework$YTDeviceAuthenticator$authenticate(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$ClassicFramework$YTDeviceAuthenticator$canAuthenticate)(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$ClassicFramework$YTDeviceAuthenticator$canAuthenticate(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST, SEL); 




static void _logos_meta_method$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSMutableURLRequest * request, BOOL includeHostHeader) {
    _logos_meta_orig$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$(self, _cmd, request, NO);
    TFLAddAPIKeyIfNeeded(request);
}













@protocol TFLDeviceAuthenticator
- (void)_succeeded;
@end




static void _logos_method$ClassicFramework$YTDeviceAuthenticator$authenticate(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    Ivar tokenIvar = class_getInstanceVariable([self class], "_token");
    Ivar timeIvar = class_getInstanceVariable([self class], "_timeTokenGranted");
    if (!tokenIvar || !timeIvar || ![self respondsToSelector:@selector(_succeeded)]) {
        _logos_orig$ClassicFramework$YTDeviceAuthenticator$authenticate(self, _cmd);
        return;
    }
    id oldToken = object_getIvar(self, tokenIvar);
    object_setIvar(self, tokenIvar, [@"TubeFixLegacy" copy]);
    [oldToken release];
    *(double *)((char *)self + ivar_getOffset(timeIvar)) = [NSDate timeIntervalSinceReferenceDate];
    TFLDebugLog(@"device login skipped (local token)");
    
    
    [self performSelector:@selector(_succeeded) withObject:nil afterDelay:0];
}


static BOOL _logos_method$ClassicFramework$YTDeviceAuthenticator$canAuthenticate(_LOGOS_SELF_TYPE_NORMAL YTDeviceAuthenticator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}





#pragma mark - Classic: background playback and lock screen controls











@protocol TFLClassicVideo
- (NSString *)title;
- (NSString *)author;
- (NSString *)ID;
@end

static MPMoviePlayerController *gTFLMoviePlayer = nil; 
static NSMutableDictionary *gTFLArtwork = nil;         

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




static id gTFLClassicPlayerViewController = nil; 

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
    [gTFLArtwork setObject:[NSNull null] forKey:videoID]; 
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

static YTMoviePlayerViewController* (*_logos_orig$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$)(_LOGOS_SELF_TYPE_INIT YTMoviePlayerViewController*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static YTMoviePlayerViewController* _logos_method$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$(_LOGOS_SELF_TYPE_INIT YTMoviePlayerViewController*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo)(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$ClassicPlayback$YTMoviePlayerViewController$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$ClassicPlayback$YTMoviePlayerViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground)(_LOGOS_SELF_TYPE_NORMAL MPMoviePlayerControllerNew* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground(_LOGOS_SELF_TYPE_NORMAL MPMoviePlayerControllerNew* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$ClassicPlayback$UIApplication$sendEvent$)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void _logos_method$ClassicPlayback$UIApplication$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void (*_logos_orig$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); static void _logos_method$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, UIEvent *); 




static YTMoviePlayerViewController* _logos_method$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$(_LOGOS_SELF_TYPE_INIT YTMoviePlayerViewController* __unused self, SEL __unused _cmd, id video, id context, id delegate) _LOGOS_RETURN_RETAINED {
    self = _logos_orig$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$(self, _cmd, video, context, delegate);
    if (self) {
        gTFLClassicPlayerViewController = self;
    }
    return self;
}



static void _logos_method$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo(self, _cmd);
    gTFLClassicPlayerViewController = self;
    TFLClassicUpdateNowPlaying();
}


static void _logos_method$ClassicPlayback$YTMoviePlayerViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTMoviePlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (gTFLClassicPlayerViewController == self) {
        gTFLClassicPlayerViewController = nil;
    }
    _logos_orig$ClassicPlayback$YTMoviePlayerViewController$dealloc(self, _cmd);
}






static BOOL _logos_method$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground(_LOGOS_SELF_TYPE_NORMAL MPMoviePlayerControllerNew* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return TFLClassicBackgroundEnabled() ? YES : _logos_orig$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground(self, _cmd);
}






static void _logos_method$ClassicPlayback$UIApplication$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEvent * event) {
    if ([event type] == UIEventTypeRemoteControl && TFLClassicHandleRemoteControl(event)) {
        return;
    }
    _logos_orig$ClassicPlayback$UIApplication$sendEvent$(self, _cmd, event);
}


static void _logos_method$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEvent * event) {
    if (TFLClassicHandleRemoteControl(event)) {
        return;
    }
    _logos_orig$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$(self, _cmd, event);
}





static void TFLSetUpClassicPlayback(void) {
    gTFLArtwork = [[NSMutableDictionary alloc] init];
    if (TFLClassicBackgroundEnabled()) {
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"PlayVideoInBackground"]];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TFLClassicPlaybackStateChanged(notification);
    }];
    [center addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        TFLClassicForgetPlayer([notification object]);
    }];
    {Class _logos_class$ClassicPlayback$YTMoviePlayerViewController = objc_getClass("YTMoviePlayerViewController"); { MSHookMessageEx(_logos_class$ClassicPlayback$YTMoviePlayerViewController, @selector(initWithVideo:context:delegate:), (IMP)&_logos_method$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$, (IMP*)&_logos_orig$ClassicPlayback$YTMoviePlayerViewController$initWithVideo$context$delegate$);}{ MSHookMessageEx(_logos_class$ClassicPlayback$YTMoviePlayerViewController, @selector(_updateForCurrentVideo), (IMP)&_logos_method$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo, (IMP*)&_logos_orig$ClassicPlayback$YTMoviePlayerViewController$_updateForCurrentVideo);}{ MSHookMessageEx(_logos_class$ClassicPlayback$YTMoviePlayerViewController, sel_registerName("dealloc"), (IMP)&_logos_method$ClassicPlayback$YTMoviePlayerViewController$dealloc, (IMP*)&_logos_orig$ClassicPlayback$YTMoviePlayerViewController$dealloc);}Class _logos_class$ClassicPlayback$MPMoviePlayerControllerNew = objc_getClass("MPMoviePlayerControllerNew"); { MSHookMessageEx(_logos_class$ClassicPlayback$MPMoviePlayerControllerNew, @selector(_shouldContinuePlaybackInBackground), (IMP)&_logos_method$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground, (IMP*)&_logos_orig$ClassicPlayback$MPMoviePlayerControllerNew$_shouldContinuePlaybackInBackground);}Class _logos_class$ClassicPlayback$UIApplication = objc_getClass("UIApplication"); { MSHookMessageEx(_logos_class$ClassicPlayback$UIApplication, @selector(sendEvent:), (IMP)&_logos_method$ClassicPlayback$UIApplication$sendEvent$, (IMP*)&_logos_orig$ClassicPlayback$UIApplication$sendEvent$);}{ MSHookMessageEx(_logos_class$ClassicPlayback$UIApplication, @selector(remoteControlReceivedWithEvent:), (IMP)&_logos_method$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$, (IMP*)&_logos_orig$ClassicPlayback$UIApplication$remoteControlReceivedWithEvent$);}}
}

#pragma mark - YouTube.framework hooks

static NSString *(*tfl_orig_serviceHostname)(void) = NULL;

static NSString *tfl_serviceHostname(void) {
    if (gTFLActive && gTFLServiceHost) {
        return gTFLServiceHost;
    }
    return tfl_orig_serviceHostname ? tfl_orig_serviceHostname() : @"gdata.youtube.com";
}



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
        {Class _logos_class$ClassicFramework$YTWebServiceConfig = objc_getClass("YTWebServiceConfig"); Class _logos_metaclass$ClassicFramework$YTWebServiceConfig = object_getClass(_logos_class$ClassicFramework$YTWebServiceConfig); { MSHookMessageEx(_logos_metaclass$ClassicFramework$YTWebServiceConfig, @selector(addYouTubeHeadersToRequest:includingHostHeader:), (IMP)&_logos_meta_method$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$, (IMP*)&_logos_meta_orig$ClassicFramework$YTWebServiceConfig$addYouTubeHeadersToRequest$includingHostHeader$);}Class _logos_class$ClassicFramework$YTDeviceAuthenticator = objc_getClass("YTDeviceAuthenticator"); { MSHookMessageEx(_logos_class$ClassicFramework$YTDeviceAuthenticator, @selector(authenticate), (IMP)&_logos_method$ClassicFramework$YTDeviceAuthenticator$authenticate, (IMP*)&_logos_orig$ClassicFramework$YTDeviceAuthenticator$authenticate);}{ MSHookMessageEx(_logos_class$ClassicFramework$YTDeviceAuthenticator, @selector(canAuthenticate), (IMP)&_logos_method$ClassicFramework$YTDeviceAuthenticator$canAuthenticate, (IMP*)&_logos_orig$ClassicFramework$YTDeviceAuthenticator$canAuthenticate);}}
    }
    dlclose(handle);
}

static __attribute__((constructor)) void _logosLocalCtor_08b255a5(int __unused argc, char __unused **argv, char __unused **envp)
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

        {Class _logos_class$_ungrouped$NSURL = objc_getClass("NSURL"); Class _logos_metaclass$_ungrouped$NSURL = object_getClass(_logos_class$_ungrouped$NSURL); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSURL, @selector(URLWithString:), (IMP)&_logos_meta_method$_ungrouped$NSURL$URLWithString$, (IMP*)&_logos_meta_orig$_ungrouped$NSURL$URLWithString$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSURL, @selector(URLWithString:relativeToURL:), (IMP)&_logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$, (IMP*)&_logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSURL, @selector(initWithString:), (IMP)&_logos_method$_ungrouped$NSURL$initWithString$, (IMP*)&_logos_orig$_ungrouped$NSURL$initWithString$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSURL, @selector(initWithString:relativeToURL:), (IMP)&_logos_method$_ungrouped$NSURL$initWithString$relativeToURL$, (IMP*)&_logos_orig$_ungrouped$NSURL$initWithString$relativeToURL$);}Class _logos_class$_ungrouped$NSURLRequest = objc_getClass("NSURLRequest"); { MSHookMessageEx(_logos_class$_ungrouped$NSURLRequest, @selector(initWithURL:cachePolicy:timeoutInterval:), (IMP)&_logos_method$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$, (IMP*)&_logos_orig$_ungrouped$NSURLRequest$initWithURL$cachePolicy$timeoutInterval$);}Class _logos_class$_ungrouped$NSMutableURLRequest = objc_getClass("NSMutableURLRequest"); { MSHookMessageEx(_logos_class$_ungrouped$NSMutableURLRequest, @selector(setURL:), (IMP)&_logos_method$_ungrouped$NSMutableURLRequest$setURL$, (IMP*)&_logos_orig$_ungrouped$NSMutableURLRequest$setURL$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSMutableURLRequest, @selector(setValue:forHTTPHeaderField:), (IMP)&_logos_method$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$, (IMP*)&_logos_orig$_ungrouped$NSMutableURLRequest$setValue$forHTTPHeaderField$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSMutableURLRequest, @selector(addValue:forHTTPHeaderField:), (IMP)&_logos_method$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$, (IMP*)&_logos_orig$_ungrouped$NSMutableURLRequest$addValue$forHTTPHeaderField$);}}
        if (isClassic) {
            TFLHookYouTubeFramework();
        }
    }
}
