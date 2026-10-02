#line 1 "googleapp/likes.x"





#include <Foundation/Foundation.h>
#import <objc/runtime.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "general.h"

#pragma mark - Request Building


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

@class YTGDataRequestFactory; @class YTGDataService; @class YTGDataRequest; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToRateWithVideoID$authentication$like$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, id, BOOL); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToRateWithVideoID$authentication$like$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, id, BOOL); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToFavoritesWithVideoID$authentication$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToFavoritesWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToRateWithVideoID$authentication$like$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString *, id, BOOL); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToRateWithVideoID$authentication$like$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString *, id, BOOL); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToFavoritesWithVideoID$authentication$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString *, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToFavoritesWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString *, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeRateRequestWithVideoID$authentication$like$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, BOOL, void (^)(void), id); static void _logos_method$_ungrouped$YTGDataService$makeRateRequestWithVideoID$authentication$like$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, BOOL, void (^)(void), id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 14 "googleapp/likes.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToRateWithVideoID$authentication$like$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * videoId, id authentication, BOOL like) {
    
    
    NSString *endpoint = like 
        ? @"https://www.youtube.com/youtubei/v1/like/like?prettyPrint=false" 
        : @"https://www.youtube.com/youtubei/v1/like/removelike?prettyPrint=false";
    
    NSData *body = [TRRequestBuilder likeBodyWithVideoId:videoId 
                                                  client:[YoutubeClientType webMobileClient]];
    
    return [self requestWithURLString:endpoint 
                       authentication:authentication 
                                 body:body];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToFavoritesWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * videoId, id authentication) {
    
    return [_logos_static_class_lookup$YTGDataRequest() requestToRateWithVideoID:videoId authentication:authentication like:YES]; 
}






static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToRateWithVideoID$authentication$like$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * videoId, id authentication, BOOL like) {
    
    
    NSString *endpoint = like 
        ? @"https://www.youtube.com/youtubei/v1/like/like?prettyPrint=false" 
        : @"https://www.youtube.com/youtubei/v1/like/removelike?prettyPrint=false";
    
    NSData *body = [TRRequestBuilder likeBodyWithVideoId:videoId 
                                                  client:[YoutubeClientType webMobileClient]];
    
    return [self requestWithURLString:endpoint 
                       authentication:authentication 
                                 body:body];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToFavoritesWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * videoId, id authentication) {
    return [self requestToRateWithVideoID:videoId authentication:authentication like:YES]; 
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeRateRequestWithVideoID$authentication$like$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id authentication, BOOL like, void (^responseBlock)(void), id errorBlock) {
    
    YTGDataRequest *request = nil;
    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
        request = [_logos_static_class_lookup$YTGDataRequest() requestToRateWithVideoID:videoId 
                                        authentication:authentication 
                                                    like:like];
    } else {
        request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestToRateWithVideoID:videoId 
                                        authentication:authentication 
                                                    like:like];
    }
    
    
    
    
    
    
    
    
    
    
    
    void (^wrappedResponseBlock)(void) = ^{
        TRSetCachedLikeState(videoId, like ? TRLikeStateLiked : TRLikeStateNeutral);
        if (responseBlock) {
            responseBlock();
        }
    };

    [self makePOSTRequest:request 
               withParser:nil 
            responseBlock:wrappedResponseBlock 
               errorBlock:errorBlock];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToRateWithVideoID:authentication:like:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToRateWithVideoID$authentication$like$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToRateWithVideoID$authentication$like$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToAddToFavoritesWithVideoID:authentication:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToFavoritesWithVideoID$authentication$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToFavoritesWithVideoID$authentication$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToRateWithVideoID:authentication:like:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToRateWithVideoID$authentication$like$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToRateWithVideoID$authentication$like$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToAddToFavoritesWithVideoID:authentication:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToFavoritesWithVideoID$authentication$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToFavoritesWithVideoID$authentication$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeRateRequestWithVideoID:authentication:like:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeRateRequestWithVideoID$authentication$like$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeRateRequestWithVideoID$authentication$like$responseBlock$errorBlock$);}} }
#line 103 "googleapp/likes.x"
