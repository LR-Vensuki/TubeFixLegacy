#line 1 "googleapp/accountfeeds.x"





#import <Foundation/Foundation.h>
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

@class YTGDataRequestFactory; @class YTGDataService; @class YTGDataRequest; @class GIPToast; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyFavoriteVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyFavoriteVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyWatchHistoryVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchHistoryVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyWatchLaterVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchLaterVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyPurchases$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPurchases$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyUploadedVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUploadedVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyFavoriteVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyFavoriteVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyWatchHistoryVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchHistoryVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyWatchLaterVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchLaterVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyUploadedVideosWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUploadedVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyFavoriteVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyFavoriteVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyWatchHistoryVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyWatchHistoryVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyWatchLaterVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyWatchLaterVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyUploadedVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyUploadedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPToast(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPToast"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 13 "googleapp/accountfeeds.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyFavoriteVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"VLLL" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchHistoryVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEhistory" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchLaterVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"VLWL" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPurchases$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    [_logos_static_class_lookup$GIPToast() showToast:@"do you really think youtube would actually let you watch any of your purchases on a decade old phone?" forDuration:4];
    return _logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyPurchases$(self, _cmd, authentication);
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUploadedVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:[authentication channelID] 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyFavoriteVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"VLLL" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchHistoryVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEhistory" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchLaterVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"VLWL" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    [_logos_static_class_lookup$GIPToast() showToast:@"do you really think youtube would actually let you watch any of your purchases on a decade old phone?" forDuration:4];
    return _logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$(self, _cmd, authentication);
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUploadedVideosWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:[authentication channelID] 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeMyFavoriteVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                            authentication:nil 
                                    body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                        client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                            authentication:nil 
                                    body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                        client:[YoutubeClientType webMobileClient]]];
        }
        
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"videoPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makeMyWatchHistoryVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        }
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"videoPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makeMyWatchLaterVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        }
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"videoPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makeMyUploadedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        }
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"videoPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyFavoriteVideosWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyFavoriteVideosWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyFavoriteVideosWithAuth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyWatchHistoryVideosWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchHistoryVideosWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyWatchHistoryVideosWithAuth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyWatchLaterVideosWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyWatchLaterVideosWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyWatchLaterVideosWithAuth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyPurchases:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPurchases$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyPurchases$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyUploadedVideosWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUploadedVideosWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyUploadedVideosWithAuth$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyFavoriteVideosWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyFavoriteVideosWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyFavoriteVideosWithAuth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyWatchHistoryVideosWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchHistoryVideosWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyWatchHistoryVideosWithAuth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyWatchLaterVideosWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyWatchLaterVideosWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyWatchLaterVideosWithAuth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyPurchases:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyPurchases$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyUploadedVideosWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUploadedVideosWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyUploadedVideosWithAuth$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyFavoriteVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyFavoriteVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyFavoriteVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyWatchHistoryVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyWatchHistoryVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyWatchHistoryVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyWatchLaterVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyWatchLaterVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyWatchLaterVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyUploadedVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyUploadedVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyUploadedVideosRequest$responseBlock$errorBlock$);}} }
#line 186 "googleapp/accountfeeds.x"
