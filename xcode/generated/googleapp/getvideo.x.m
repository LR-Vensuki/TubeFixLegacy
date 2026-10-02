#line 1 "googleapp/getvideo.x"






#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#include "appheaders.h"
#include "general.h"
#include "Translators/TRTranslators.h"
#include "TRPlayerRequest.h"


@interface YTVideoParser : NSObject
-(id)parseElement:(id)fp8 error:(id *)fp12;

-(NSDictionary *)fetchNextDataForVideoId:(NSString *)videoId;
-(void)enhanceVideo:(id)video withNextData:(NSDictionary *)nextData;
@end

#pragma mark - Player request




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

@class YTGDataService; @class YTVideoParser; @class GIPToast; @class GTMURLBuilder; @class __NSCFString; @class YTGDataRequest; 
static void (*_logos_orig$_ungrouped$YTGDataService$makeVideoRequestWithVideoID$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeVideoRequestWithVideoID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static YTVideo* (*_logos_orig$_ungrouped$YTVideoParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTVideoParser* _LOGOS_SELF_CONST, SEL, id, NSError*); static YTVideo* _logos_method$_ungrouped$YTVideoParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTVideoParser* _LOGOS_SELF_CONST, SEL, id, NSError*); static NSDictionary * _logos_method$_ungrouped$YTVideoParser$fetchNextDataForVideoId$(_LOGOS_SELF_TYPE_NORMAL YTVideoParser* _LOGOS_SELF_CONST, SEL, NSString *); static id _logos_method$_ungrouped$__NSCFString$host(_LOGOS_SELF_TYPE_NORMAL __NSCFString* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GTMURLBuilder(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GTMURLBuilder"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPToast(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPToast"); } return _klass; }
#line 47 "googleapp/getvideo.x"
NSURL *TRPlayerRequestURL(void) {
    NSString *requestURL = nil;
    TRPlayerClient(&requestURL);
    return [[_logos_static_class_lookup$GTMURLBuilder() builderWithString:requestURL] URL] ?: [NSURL URLWithString:requestURL];
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



static void _logos_method$_ungrouped$YTGDataService$makeVideoRequestWithVideoID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id responseBlock, id errorBlock) {
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
            request = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:fullURL authentication:nil body:body];
        } else {
            request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:fullURL authentication:nil body:body];
        }
        [self makePOSTRequest:request 
                    withParser:[self valueForKey:l(@"videoParser")] 
                    responseBlock:responseBlock2 
                    errorBlock:errorBlock2];
    }
}



#pragma mark - Video Parsing



static YTVideo* _logos_method$_ungrouped$YTVideoParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTVideoParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id body, NSError* error) {
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


static NSDictionary * _logos_method$_ungrouped$YTVideoParser$fetchNextDataForVideoId$(_LOGOS_SELF_TYPE_NORMAL YTVideoParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * videoId) {
    
    
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];

    if (!(preferences[@"StreamType"] == nil || [preferences[@"StreamType"] isEqualToString:@"web"] || [preferences[@"StreamType"] isEqualToString:@"mweb"])) {
        NSURL *url = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"];
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        

        [request setHTTPBody:[TRRequestBuilder nextBodyWithVideoId:videoId 
                                                            client:[YoutubeClientType webMobileClient]]];
        
        
        NSURLResponse *response = nil;
        NSError *reqError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&reqError];
        
        if (!reqError && data) {
            NSError *jsonError = nil;

            allData[@"next"] = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        }
    }

    
    
    id rawUseRTYDL = preferences[@"UseRTYDL"];
    BOOL useRTYDL = rawUseRTYDL ? [rawUseRTYDL boolValue] : YES; 

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







static id _logos_method$_ungrouped$__NSCFString$host(_LOGOS_SELF_TYPE_NORMAL __NSCFString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"String got a host call!");
    [_logos_static_class_lookup$GIPToast() showTodo];
    return nil; 
}




static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeVideoRequestWithVideoID:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeVideoRequestWithVideoID$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeVideoRequestWithVideoID$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTVideoParser = objc_getClass("YTVideoParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTVideoParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTVideoParser$parseElement$error$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTVideoParser, @selector(fetchNextDataForVideoId:), (IMP)&_logos_method$_ungrouped$YTVideoParser$fetchNextDataForVideoId$, _typeEncoding); }Class _logos_class$_ungrouped$__NSCFString = objc_getClass("__NSCFString"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$__NSCFString, @selector(host), (IMP)&_logos_method$_ungrouped$__NSCFString$host, _typeEncoding); }} }
#line 207 "googleapp/getvideo.x"
