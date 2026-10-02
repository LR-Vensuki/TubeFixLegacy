// getvideo.x
// TubeFixLegacy
//
// Video detail request and parsing hooks
// Makes both /player (for streams) and /next (for likes) requests

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#include "appheaders.h"
#include "general.h"
#include "Translators/TRTranslators.h"
#include "TRPlayerRequest.h"

// Forward declare new methods for YTVideoParser
@interface YTVideoParser : NSObject
-(id)parseElement:(id)fp8 error:(id *)fp12;
// New methods
-(NSDictionary *)fetchNextDataForVideoId:(NSString *)videoId;
-(void)enhanceVideo:(id)video withNextData:(NSDictionary *)nextData;
@end

#pragma mark - Player request

// The client picked in settings ("Stream type"): web (default) and mweb
// need a PO token, the others are asked without authentication (noauth=1
// keeps SSOAuthorizationImpl from signing the request).
static YoutubeClientType *TRPlayerClient(NSString **requestURL) {
    NSDictionary *preferences = TRPreferences();
    NSString *streamType = [preferences objectForKey:@"StreamType"];
    *requestURL = @"https://www.youtube.com/youtubei/v1/player?prettyPrint=false";
    if ([streamType isEqualToString:@"mweb"]) {
        return [YoutubeClientType webMobileClient];
    } else if ([streamType isEqualToString:@"visionos"]) {
        *requestURL = @"https://www.youtube.com/youtubei/v1/player?prettyPrint=false&noauth=1";
        return [YoutubeClientType visionOSClient];
    } else if ([streamType isEqualToString:@"android"]) {
        *requestURL = @"https://www.youtube.com/youtubei/v1/player?prettyPrint=false&noauth=1";
        return [YoutubeClientType androidClient];
    } else if ([streamType isEqualToString:@"androidvr"]) {
        *requestURL = @"https://www.youtube.com/youtubei/v1/player?prettyPrint=false&noauth=1";
        return [YoutubeClientType androidVrClient];
    }
    return [YoutubeClientType webClient];
}

NSURL *TRPlayerRequestURL(void) {
    NSString *requestURL = nil;
    TRPlayerClient(&requestURL);
    return [[%c(GTMURLBuilder) builderWithString:requestURL] URL] ?: [NSURL URLWithString:requestURL];
}

NSData *TRPlayerRequestBody(NSString *videoId) {
    NSString *requestURL = nil;
    YoutubeClientType *client = TRPlayerClient(&requestURL);
    NSString *streamType = [TRPreferences() objectForKey:@"StreamType"];
    TRPOTokenSolver *challengeSolver = [TRPOTokenSolver sharedInstance];
    NSString *poToken = @"";
    if ([streamType isEqualToString:@"web"] || [streamType isEqualToString:@"mweb"]) {
        poToken = [challengeSolver mintPOTokenOrColdStart:videoId] ?: @"";
    }
    return [TRRequestBuilder playerBodyWithVideoId:videoId
                                           poToken:poToken
                                signatureTimestamp:@([challengeSolver nsigSignatureTimestamp])
                                            client:client];
}

#pragma mark - Request Dispatch

%hook YTGDataService

-(void)makeVideoRequestWithVideoID:(NSString*)videoId responseBlock:(id)responseBlock errorBlock:(id)errorBlock {
    id videoCache = [self valueForKey:l(@"videoCache")];
    id cachedVideo = [videoCache objectForKey:videoId];
   
   

    if (cachedVideo) {
        [self performResponseBlock:responseBlock response:cachedVideo];
    } else {
        id responseBlock2 = [responseBlock copy];
        id errorBlock2 = [errorBlock copy];
        NSURL *fullURL = TRPlayerRequestURL();
        NSData *body = TRPlayerRequestBody(videoId);

        YTGDataRequest *request = nil;
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            request = [%c(YTGDataRequest) requestWithURL:fullURL authentication:nil body:body];
        } else {
            request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:fullURL authentication:nil body:body];
        }
        [self makePOSTRequest:request 
                    withParser:[self valueForKey:l(@"videoParser")] 
                    responseBlock:responseBlock2 
                    errorBlock:errorBlock2];
    }
}

%end

#pragma mark - Video Parsing

%hook YTVideoParser

-(YTVideo*)parseElement:(id)body error:(NSError*)error {
    if (![body isKindOfClass:[NSDictionary class]]) {
        NSLog(@"YTVideoParser: input is not NSDictionary");
        return nil;
    }
    
    TRVideoTranslator *translator = [[[TRVideoTranslator alloc] init] autorelease];
    NSError *translatorError = nil;
    id video = [translator translateJSON:body error:&translatorError];
    
    if (translatorError) {
        NSLog(@"TRVideoTranslator error: %@", translatorError);
        return nil;
    }
    
    // Enhance with /next data for like counts
    NSString *videoId = [TRJSONUtils stringFromJSON:body keyPath:@"videoDetails.videoId"];
    
    if (videoId && video) {
        @try {
            NSDictionary *nextData = [self fetchNextDataForVideoId:videoId];
            if (nextData) {
                [translator enhanceVideo:video withNextResponse:nextData];
            }
        } @catch (NSException *e) {
            NSLog(@"Failed to fetch /next data: %@", e);
        }
    }
    
    return video;
}

%new
-(NSDictionary *)fetchNextDataForVideoId:(NSString *)videoId {
    // Synchronous request to /next endpoint
    // Consider making this async for better UX BUT im lazy
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];

    if (!(preferences[@"StreamType"] == nil || [preferences[@"StreamType"] isEqualToString:@"web"] || [preferences[@"StreamType"] isEqualToString:@"mweb"])) {
        NSURL *url = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"];
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        

        [request setHTTPBody:[TRRequestBuilder nextBodyWithVideoId:videoId 
                                                            client:[YoutubeClientType webMobileClient]]];
        // TODO: figure out how to get authentication here
        // [authentication authorizeNSRequest:&request];
        NSURLResponse *response = nil;
        NSError *reqError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&reqError];
        
        if (!reqError && data) {
            NSError *jsonError = nil;

            allData[@"next"] = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        }
    }

    
    // TODO: this should be running at the same time as the next request
    id rawUseRTYDL = preferences[@"UseRTYDL"];
    BOOL useRTYDL = rawUseRTYDL ? [rawUseRTYDL boolValue] : YES; // default YES when unset

    if (!useRTYDL) {
        return allData;
    }
    NSURL *rytdl = [NSURL URLWithString:[NSString stringWithFormat:@"https://returnyoutubedislikeapi.com/votes?videoId=%@", videoId]];
    
    NSMutableURLRequest *requestDL = [NSMutableURLRequest requestWithURL:rytdl];
    [requestDL setHTTPMethod:@"GET"];
    
    NSURLResponse *responseDL = nil;
    NSError *reqErrorDL = nil;
    NSData *dataDL = [NSURLConnection sendSynchronousRequest:requestDL returningResponse:&responseDL error:&reqErrorDL];
    
    if (!reqErrorDL && dataDL) {
        NSError *jsonErrorDL = nil;
        allData[@"dislikes"] = [NSJSONSerialization JSONObjectWithData:dataDL options:0 error:&jsonErrorDL];
    }
    
    return allData;
}

%end

// this is just for debugging setting strings as NSURL
%hook __NSCFString

%new
-(id)host {
    NSLog(@"String got a host call!");
    [%c(GIPToast) showTodo];
    return nil; // things go wrong here
}
%end

// Background playback lives in playback.x.

