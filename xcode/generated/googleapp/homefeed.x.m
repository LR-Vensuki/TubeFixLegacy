#line 1 "googleapp/homefeed.x"





#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "Translators/TRContinuation.h"
#include "general.h"

#pragma mark - Request Dispatch


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

@class YTGDataService; @class YTGDataRequest; @class YTGDataRequestFactory; 
static void (*_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionUploadsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionUploadsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionEventsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionEventsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionUploadsWithAuth$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, BOOL); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUploadsWithAuth$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, BOOL); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionUpdatesWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUpdatesWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUploadsWithAuth$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, BOOL); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUploadsWithAuth$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, BOOL); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUpdatesWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUpdatesWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 14 "googleapp/homefeed.x"


static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionUploadsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {

    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
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

static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionEventsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {

    id actualRequest = request;
    if ([[request URL] isKindOfClass:[TRContinuation class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[[request URL] token]
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[[request URL] token]
                                                                client:[YoutubeClientType webMobileClient]]];
        }
    }
    

    NSLog(@"makeMySubscriptionEventsRequest");
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"eventPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}



#pragma mark - Request Building



static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUploadsWithAuth$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication, BOOL isSafeSearch) {
    NSLog(@"+[<YTGDataRequest: %p> requestForMySubscriptionUploadsWithAuth:%@ safeSearch:%d]", self, authentication, isSafeSearch);
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEsubscriptions" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUpdatesWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEwhat_to_watch" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUploadsWithAuth$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication, BOOL isSafeSearch) {
    NSLog(@"-[<YTGDataRequestFactory: %p> requestForMySubscriptionUploadsWithAuth:%@ safeSearch:%d]", self, authentication, isSafeSearch);
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEsubscriptions" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUpdatesWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:@"FEwhat_to_watch" 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMySubscriptionUploadsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMySubscriptionUploadsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionUploadsRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMySubscriptionEventsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMySubscriptionEventsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionEventsRequest$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMySubscriptionUploadsWithAuth:safeSearch:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUploadsWithAuth$safeSearch$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionUploadsWithAuth$safeSearch$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMySubscriptionUpdatesWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionUpdatesWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionUpdatesWithAuth$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMySubscriptionUploadsWithAuth:safeSearch:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUploadsWithAuth$safeSearch$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUploadsWithAuth$safeSearch$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMySubscriptionUpdatesWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUpdatesWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionUpdatesWithAuth$);}} }
#line 109 "googleapp/homefeed.x"
