#line 1 "googleapp/handlevideo.x"








#include <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>
#include "appheaders.h"
#include "general.h"
#include "common/SABR/TRSabrStream.h"

@interface YTStream (TFLInternal)
+(YTStream*)internalSelectStreamForVideo:(YTVideo*)video maxQualityStreamFormat:(int)maxQualityStreamFormat onWiFi:(BOOL)onWifi devicePrivileges:(id)devicePrivileges CPN:(NSString*)cpn;
@end



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

@class MLPassThroughProxy; @class YTPBStreamingData; @class YTWatchViewController_iPhone; @class YTStream; @class YTPlayerController; @class YTPlayerViewController; 
static YTStream* _logos_meta_method$_ungrouped$YTStream$internalSelectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, int, BOOL, id, NSString*); static YTStream* (*_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$onWiFi$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL); static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL); static YTStream* (*_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$onWiFi$devicePrivileges$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, id); static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$devicePrivileges$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, id); static YTStream* (*_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, int, BOOL, id, NSString*); static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTVideo*, int, BOOL, id, NSString*); static void (*_logos_orig$_ungrouped$YTPlayerController$setAndPlayVideoStream$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, YTStream *); static void _logos_method$_ungrouped$YTPlayerController$setAndPlayVideoStream$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, YTStream *); static MLRemoteStream* (*_logos_orig$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, YTStream*, NSURL*); static MLRemoteStream* _logos_method$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, YTStream*, NSURL*); static void (*_logos_orig$_ungrouped$YTPlayerController$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$reloadPlayerStream(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$willLoseFocus)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerController$willLoseFocus(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, MLStreamManifest*, id, BOOL); static void _logos_method$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST, SEL, MLStreamManifest*, id, BOOL); static MLRemoteStream* (*_logos_orig$_ungrouped$MLPassThroughProxy$selectStream)(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static MLRemoteStream* _logos_method$_ungrouped$MLPassThroughProxy$selectStream(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MLPassThroughProxy$stop)(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MLPassThroughProxy$stop(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$MLPassThroughProxy$start$)(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL, NSError**); static BOOL _logos_method$_ungrouped$MLPassThroughProxy$start$(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL, NSError**); static void (*_logos_orig$_ungrouped$MLPassThroughProxy$start)(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MLPassThroughProxy$start(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MLPassThroughProxy$reloadPlayerStream(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST, SEL); static YTPBStreamingData * (*_logos_meta_orig$_ungrouped$YTPBStreamingData$streamingDataWithStreams$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSArray*); static YTPBStreamingData * _logos_meta_method$_ungrouped$YTPBStreamingData$streamingDataWithStreams$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSArray*); static void (*_logos_orig$_ungrouped$YTPlayerViewController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL, MLStreamManifest*, id, BOOL); static void _logos_method$_ungrouped$YTPlayerViewController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL, MLStreamManifest*, id, BOOL); static YTWatchViewController_iPhone* (*_logos_orig$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$)(_LOGOS_SELF_TYPE_INIT YTWatchViewController_iPhone*, SEL, id, int, id, id) _LOGOS_RETURN_RETAINED; static YTWatchViewController_iPhone* _logos_method$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$(_LOGOS_SELF_TYPE_INIT YTWatchViewController_iPhone*, SEL, id, int, id, id) _LOGOS_RETURN_RETAINED; 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTStream(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTStream"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MLPassThroughProxy(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MLPassThroughProxy"); } return _klass; }
#line 20 "googleapp/handlevideo.x"



static YTStream* _logos_meta_method$_ungrouped$YTStream$internalSelectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, int maxQualityStreamFormat, BOOL onWifi, id devicePrivileges, NSString* cpn) {
    NSArray *streams = [video streams];
    
    
    YTStream *selectedStream = nil;
    
    for (YTStream *stream in streams) {
        if ([stream format] == 5) {
            
            TRSabrStream *sabrStream = (TRSabrStream*)stream;
            if ([sabrStream isStreamBad]) {
                NSLog(@"SABR stream is bad! lets not use it...");
                continue;
            }
        }
        if ([stream format] == 2)
            return stream; 
        if ([stream format] > [selectedStream format])
            selectedStream = stream;
    }

    NSLog(@"selected new stream -> %@", selectedStream);
    return selectedStream;

}

static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, BOOL onWifi) {
    return [_logos_static_class_lookup$YTStream() internalSelectStreamForVideo:video maxQualityStreamFormat:-1 onWiFi:onWifi devicePrivileges:nil CPN:nil];
}

static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$devicePrivileges$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, BOOL onWifi, id devicePrivileges) {
    return [_logos_static_class_lookup$YTStream() internalSelectStreamForVideo:video maxQualityStreamFormat:-1 onWiFi:onWifi devicePrivileges:devicePrivileges CPN:nil];
}


static YTStream* _logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, int maxQualityStreamFormat, BOOL onWifi, id devicePrivileges, NSString* cpn) {
    return [_logos_static_class_lookup$YTStream() internalSelectStreamForVideo:video maxQualityStreamFormat:-1 onWiFi:onWifi devicePrivileges:devicePrivileges CPN:cpn];
}






static void _logos_method$_ungrouped$YTPlayerController$setAndPlayVideoStream$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTStream * stream) {
    BOOL version10 = ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]);

    YTPlayer *player = [self valueForKey:l(@"player")];
    
    
    if ([stream format] == 5) {
        TRSabrStream *sabrStream = (TRSabrStream*)stream;
        NSLog(@"format -> %i", [stream format]);
        sabrStream.currentPlayerTimeFunction = ^double{
            return [player currentMediaTime];
        };

        sabrStream.reloadPlayerFunction = ^{
            [self reloadPlayerStream];
        };

        if (version10) {
            sabrStream.authentication = [[(YTServices*)[self valueForKey:l(@"services")] userAuthenticator] authentication];
        } else {
            sabrStream.authentication = [[(YTPlayerServices*)[self valueForKey:l(@"playerServices")] userAuth] authentication];
        }

        [sabrStream start];
    }
    
    return _logos_orig$_ungrouped$YTPlayerController$setAndPlayVideoStream$(self, _cmd, stream);
}


static MLRemoteStream* _logos_method$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTStream* stream, NSURL* url) {
    if ([stream format] == 5) {
        return (MLRemoteStream*)stream;
    }
    return _logos_orig$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$(self, _cmd, stream, url);
}

static void _logos_method$_ungrouped$YTPlayerController$dealloc(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    if ([(YTStream*)[self valueForKey:l(@"videoStream")] format] == 5) {
      
        [[[self valueForKey:l(@"videoStream")] URL] release];
    }
    return _logos_orig$_ungrouped$YTPlayerController$dealloc(self, _cmd);
}




static void _logos_method$_ungrouped$YTPlayerController$reloadPlayerStream(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"reloading stream...");
    BOOL version10 = [version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"];
    if (!version10)
      [self saveMediaTime];
    
    
    

    YTStream *selectedStream = nil;
    if ([version() isEqualToString:@"1.2.1"] || [version() isEqualToString:@"1.3.0"])
        selectedStream = [self selectStreamForVideo:[self valueForKey:l(@"video")] maxQualityStreamFormat:9999 devicePrivileges:[self valueForKey:l(@"privileges")] CPN:[self valueForKey:l(@"videoCPN")]];
    else if ([version() isEqualToString:@"1.1.0"])
        selectedStream = [self selectStreamForVideo:[self valueForKey:l(@"video")] devicePrivileges:nil];
    else
        selectedStream = [self selectStreamForVideo:[self valueForKey:l(@"video")]];

    
    if (version10) {
        [self setAndPlayVideoStream:selectedStream];
    } else {
        BOOL isPlaying = [(AVPlayer*)([[self valueForKey:l(@"player")] valueForKey:l(@"player")]) rate] != 0;
        [self setValue:@(isPlaying) forKey:l(@"startPlayback")];
        if ( selectedStream != nil)
        {
            if (![selectedStream isEqual:(YTStream*)[self valueForKey:l(@"videoStream")]])
            {
                NSLog(@"switching streams to -> %@", selectedStream);
                [(YTStream*)[self valueForKey:l(@"videoStream")] autorelease];
                [self setValue:[selectedStream retain] forKey:l(@"videoStream")];
            }
        }
        NSLog(@"video stream -> %@", [self valueForKey:l(@"videoStream")]);
        
        
        
        [self setAndPlayVideoStream:[self valueForKey:l(@"videoStream")]];
        
        
    }
    
}

static void _logos_method$_ungrouped$YTPlayerController$willLoseFocus(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerController$willLoseFocus(self, _cmd);
    if ([version() isEqualToString:@"1.4.0"]) {
        if ([self valueForKey:l(@"player")] != nil && [[[self valueForKey:l(@"player")] valueForKey:l(@"proxy")] isKindOfClass:[_logos_static_class_lookup$MLPassThroughProxy() class]]) {
            if ([[(MLPassThroughProxy*)[[self valueForKey:l(@"player")] valueForKey:l(@"proxy")] valueForKey:l(@"selectedStream")] isKindOfClass:[TRSabrStream class]]) {
                TRSabrStream *sabrStream = [(MLPassThroughProxy*)[[self valueForKey:l(@"player")] valueForKey:l(@"proxy")] valueForKey:l(@"selectedStream")];

                NSLog(@"trimming segments");
                [sabrStream trimSegments];
            }
        }
    } else {
        if ([[self valueForKey:l(@"videoStream")] isKindOfClass:[TRSabrStream class]]) {
            TRSabrStream *sabrStream = [self valueForKey:l(@"videoStream")];

            NSLog(@"trimming segments");
            [sabrStream trimSegments];
        }
    }
}











static MLRemoteStream* _logos_method$_ungrouped$MLPassThroughProxy$selectStream(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSArray *streams = [(MLStreamManifest*)[self valueForKey:l(@"streamManifest")] remoteStreams];
    NSLog(@"streams to select from -> %@", streams);

    
    MLRemoteStream *selectedStream = nil;
    
    for (MLRemoteStream *stream in streams) {
        if ([stream format] == 5) {
            
            TRSabrStream *sabrStream = (TRSabrStream*)stream;
            if ([sabrStream isStreamBad])
                continue;
        }
        if ([stream format] == 2)
            return stream; 
        if ([stream format] > [selectedStream format])
            selectedStream = stream;
    }

    NSLog(@"selected new stream -> %@", selectedStream);
    return selectedStream;
}

static void _logos_method$_ungrouped$MLPassThroughProxy$stop(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    MLRemoteStream *selectedStream = [self valueForKey:l(@"selectedStream")];

    if ([selectedStream format] == 5) {
        [(TRSabrStream*)selectedStream cleanup];
    }

    _logos_orig$_ungrouped$MLPassThroughProxy$stop(self, _cmd);
}






static YTPBStreamingData * _logos_meta_method$_ungrouped$YTPBStreamingData$streamingDataWithStreams$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSArray* streams) {
    NSMutableArray *newStreams = [[NSMutableArray alloc] initWithCapacity:streams.count];
    for (YTStream *stream in streams) {
        if ([stream format] == 5)
            continue;
        [newStreams addObject:stream];
    }

    return _logos_meta_orig$_ungrouped$YTPBStreamingData$streamingDataWithStreams$(self, _cmd, newStreams);
}





static void _logos_method$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$(_LOGOS_SELF_TYPE_NORMAL YTPlayerController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MLStreamManifest* streamManifest, id deviceCapabilities, BOOL airPlayAllowed)  {
    if (objc_getAssociatedObject(streamManifest, "sabrHackApplied") == NULL) {
        YTPlayerServices *playerServices = [self valueForKey:l(@"playerServices")];

        YTUserAuthenticator *userAuthenticatior = [playerServices userAuth];
        id authentication = [userAuthenticatior authentication];

        for (MLRemoteStream *stream in [streamManifest valueForKey:l(@"remoteStreams")]) {
            
            if ([stream format] == 5) {
                TRSabrStream *sabrStream = (TRSabrStream*)stream;

                
                if (authentication != nil) {
                    if ([version() isEqualToString:@"1.4.0"])
                        sabrStream.authentication = authentication;
                    else
                        sabrStream.authentication = [[(SSOAuthorizationImpl*)authentication identity] auth];
                }
            }
        }
        objc_setAssociatedObject(streamManifest, "sabrHackApplied", @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _logos_orig$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$(self, _cmd, streamManifest, deviceCapabilities, airPlayAllowed);
}










static void _logos_method$_ungrouped$YTPlayerViewController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, MLStreamManifest* streamManifest, id deviceCapabilities, BOOL airPlayAllowed) {
    NSLog(@"loadPlayer called!");
    [[self valueForKey:l(@"activePlayerOverlayViewController")] setAirPlayAllowed:airPlayAllowed];

    YTPlayerServices *playerServices = [self valueForKey:l(@"playerServices")];
    double savedMediaTime = [(NSNumber*)[self valueForKey:l(@"savedMediaTime")] doubleValue];

    YTUserAuthenticator *userAuthenticatior = [playerServices userAuthenticator];
    id authentication = [userAuthenticatior authentication];

    
    if (objc_getAssociatedObject(streamManifest, "sabrHackApplied") == NULL) {
        NSMutableArray *manifestStreams = [[streamManifest valueForKey:l(@"remoteStreams")] mutableCopy];

        NSArray *gdataStreams = [(YTVideo*)[self valueForKey:l(@"video")] streams];
        for (YTStream *stream in gdataStreams) {
            
            if ([stream format] == 5) {
                TRSabrStream *sabrStream = (TRSabrStream*)stream;

                
                if (authentication != nil) {
                    if ([version() isEqualToString:@"1.4.0"])
                        sabrStream.authentication = authentication;
                    else
                        sabrStream.authentication = [[(SSOAuthorizationImpl*)authentication identity] auth];
                }
                
                [manifestStreams addObject:sabrStream];
            }
        }
        [streamManifest setValue:[manifestStreams copy] forKey:l(@"remoteStreams")];
        [manifestStreams release];
        objc_setAssociatedObject(streamManifest, "sabrHackApplied", @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    

    [(MLPlayer*)[self valueForKey:l(@"player")] loadWithStreamManifest:streamManifest
                                    deviceCapabilities:deviceCapabilities
                                    services:playerServices
                                    initialMediaTime:savedMediaTime
                                    airPlayAllowed:airPlayAllowed
                                    authentication:authentication
        ];

    [self setValue:@(0.0) forKey:l(@"savedMediaTime")];
}



@interface MLPassThroughProxy (TFL)
-(void)reloadPlayerStream;
@end




static BOOL _logos_method$_ungrouped$MLPassThroughProxy$start$(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSError** error) {
    MLRemoteStream *selectedStream = [self selectStream];
    MLRemoteStream *oldSelectedStream = [self valueForKey:l(@"selectedStream")];
    [self setValue:selectedStream forKey:l(@"selectedStream")];
    [oldSelectedStream release];

    if (selectedStream != nil)
    {
        if ([selectedStream format] == 5) {
            TRSabrStream *sabrStream = (TRSabrStream*)selectedStream;
            sabrStream.currentPlayerTimeFunction = ^double{
                
                return 0.0; 
            };

            sabrStream.reloadPlayerFunction = ^{
                [self reloadPlayerStream];
            };

            [sabrStream start];
        }
        return YES;
    }
    else
    {
        *error = [NSError errorWithDomain:@"com.google.ios.medialib.ErrorDomain.Player" code:1 userInfo:nil];
        return NO;
    }
}


static void _logos_method$_ungrouped$MLPassThroughProxy$start(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    MLRemoteStream *selectedStream = [self selectStream];
    MLRemoteStream *oldSelectedStream = [self valueForKey:l(@"selectedStream")];
    [self setValue:selectedStream forKey:l(@"selectedStream")];
    [oldSelectedStream release];

    if (selectedStream != nil)
    {
        if ([selectedStream format] == 5) {
            TRSabrStream *sabrStream = (TRSabrStream*)selectedStream;
            sabrStream.currentPlayerTimeFunction = ^double{
                
                return 0.0; 
            };

            sabrStream.reloadPlayerFunction = ^{
                [self reloadPlayerStream];
            };

            [sabrStream start];
        }
        MLPlayer *delegate = [self delegate];
        NSURL *streamURL = [selectedStream URL];
        [delegate proxy:self didSetURL:streamURL];
        [delegate release];
    }
    else
    {
        NSError *error = [NSError playerErrorWithCode:1];
        
        [error release];
    }
}



static void _logos_method$_ungrouped$MLPassThroughProxy$reloadPlayerStream(_LOGOS_SELF_TYPE_NORMAL MLPassThroughProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    MLPlayer *delegate = [self delegate];
    AVPlayer *videoPlayer = [delegate valueForKey:l(@"player")];
    BOOL isCurrentlyPlaying = [videoPlayer rate] != 0.0;
    [delegate proxyURLWillChange:self];
    [delegate setValue:@(isCurrentlyPlaying) forKey:l(@"pendingPlay")];
    
    if ([version() isEqualToString:@"1.4.0"])
        [delegate proxy:self didChangeURL:[(MLRemoteStream*)[self valueForKey:l(@"selectedStream")] URL]];
    else
        [delegate proxy:self didSetURL:[(MLRemoteStream*)[self valueForKey:l(@"selectedStream")] URL]];
}




  




















 
















































static YTWatchViewController_iPhone* _logos_method$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$(_LOGOS_SELF_TYPE_INIT YTWatchViewController_iPhone* __unused self, SEL __unused _cmd, id videoId, int source, id services, id navigation) _LOGOS_RETURN_RETAINED {
    return _logos_orig$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$(self, _cmd, videoId, source, services, navigation);
}




  














static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTStream = objc_getClass("YTStream"); Class _logos_metaclass$_ungrouped$YTStream = object_getClass(_logos_class$_ungrouped$YTStream); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(YTStream*), strlen(@encode(YTStream*))); i += strlen(@encode(YTStream*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(YTVideo*), strlen(@encode(YTVideo*))); i += strlen(@encode(YTVideo*)); _typeEncoding[i] = 'i'; i += 1; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$YTStream, @selector(internalSelectStreamForVideo:maxQualityStreamFormat:onWiFi:devicePrivileges:CPN:), (IMP)&_logos_meta_method$_ungrouped$YTStream$internalSelectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$, _typeEncoding); }{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTStream, @selector(selectStreamForVideo:onWiFi:), (IMP)&_logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$, (IMP*)&_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$onWiFi$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTStream, @selector(selectStreamForVideo:onWiFi:devicePrivileges:), (IMP)&_logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$onWiFi$devicePrivileges$, (IMP*)&_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$onWiFi$devicePrivileges$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTStream, @selector(selectStreamForVideo:maxQualityStreamFormat:onWiFi:devicePrivileges:CPN:), (IMP)&_logos_meta_method$_ungrouped$YTStream$selectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$, (IMP*)&_logos_meta_orig$_ungrouped$YTStream$selectStreamForVideo$maxQualityStreamFormat$onWiFi$devicePrivileges$CPN$);}Class _logos_class$_ungrouped$YTPlayerController = objc_getClass("YTPlayerController"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(setAndPlayVideoStream:), (IMP)&_logos_method$_ungrouped$YTPlayerController$setAndPlayVideoStream$, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$setAndPlayVideoStream$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(remoteStreamFromYTStream:withURL:), (IMP)&_logos_method$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$remoteStreamFromYTStream$withURL$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$YTPlayerController$dealloc, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$dealloc);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTPlayerController, @selector(reloadPlayerStream), (IMP)&_logos_method$_ungrouped$YTPlayerController$reloadPlayerStream, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(willLoseFocus), (IMP)&_logos_method$_ungrouped$YTPlayerController$willLoseFocus, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$willLoseFocus);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerController, @selector(loadPlayerWithStreamManifest:deviceCapabilities:airPlayAllowed:), (IMP)&_logos_method$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$, (IMP*)&_logos_orig$_ungrouped$YTPlayerController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$);}Class _logos_class$_ungrouped$MLPassThroughProxy = objc_getClass("MLPassThroughProxy"); { MSHookMessageEx(_logos_class$_ungrouped$MLPassThroughProxy, @selector(selectStream), (IMP)&_logos_method$_ungrouped$MLPassThroughProxy$selectStream, (IMP*)&_logos_orig$_ungrouped$MLPassThroughProxy$selectStream);}{ MSHookMessageEx(_logos_class$_ungrouped$MLPassThroughProxy, @selector(stop), (IMP)&_logos_method$_ungrouped$MLPassThroughProxy$stop, (IMP*)&_logos_orig$_ungrouped$MLPassThroughProxy$stop);}{ MSHookMessageEx(_logos_class$_ungrouped$MLPassThroughProxy, @selector(start:), (IMP)&_logos_method$_ungrouped$MLPassThroughProxy$start$, (IMP*)&_logos_orig$_ungrouped$MLPassThroughProxy$start$);}{ MSHookMessageEx(_logos_class$_ungrouped$MLPassThroughProxy, @selector(start), (IMP)&_logos_method$_ungrouped$MLPassThroughProxy$start, (IMP*)&_logos_orig$_ungrouped$MLPassThroughProxy$start);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MLPassThroughProxy, @selector(reloadPlayerStream), (IMP)&_logos_method$_ungrouped$MLPassThroughProxy$reloadPlayerStream, _typeEncoding); }Class _logos_class$_ungrouped$YTPBStreamingData = objc_getClass("YTPBStreamingData"); Class _logos_metaclass$_ungrouped$YTPBStreamingData = object_getClass(_logos_class$_ungrouped$YTPBStreamingData); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTPBStreamingData, @selector(streamingDataWithStreams:), (IMP)&_logos_meta_method$_ungrouped$YTPBStreamingData$streamingDataWithStreams$, (IMP*)&_logos_meta_orig$_ungrouped$YTPBStreamingData$streamingDataWithStreams$);}Class _logos_class$_ungrouped$YTPlayerViewController = objc_getClass("YTPlayerViewController"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(loadPlayerWithStreamManifest:deviceCapabilities:airPlayAllowed:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$loadPlayerWithStreamManifest$deviceCapabilities$airPlayAllowed$);}Class _logos_class$_ungrouped$YTWatchViewController_iPhone = objc_getClass("YTWatchViewController_iPhone"); { MSHookMessageEx(_logos_class$_ungrouped$YTWatchViewController_iPhone, @selector(initWithVideoID:source:services:navigation:), (IMP)&_logos_method$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$, (IMP*)&_logos_orig$_ungrouped$YTWatchViewController_iPhone$initWithVideoID$source$services$navigation$);}} }
#line 512 "googleapp/handlevideo.x"
