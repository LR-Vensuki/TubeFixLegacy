#line 1 "googleapp/suggestedvideos.x"





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

@class YTGDataRequestFactory; @class YTGDataRequest; @class YTGDataService; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForRelatedVideosWithURL$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForRelatedVideosWithURL$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$count$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, id, unsigned int); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$count$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id, id, unsigned int); static void (*_logos_orig$_ungrouped$YTGDataService$makeRelatedVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeRelatedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 13 "googleapp/suggestedvideos.x"
 

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForRelatedVideosWithURL$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id videoId, id safeSearch) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder nextBodyWithVideoId:videoId 
                                                               client:[YoutubeClientType webMobileClient]]];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id videoId, id safeSearch) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder nextBodyWithVideoId:videoId 
                                                               client:[YoutubeClientType webMobileClient]]];
}


static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$count$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id videoId, id safeSearch, unsigned int count) {
    
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder nextBodyWithVideoId:videoId 
                                                               client:[YoutubeClientType webMobileClient]]];
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeRelatedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/next?prettyPrint=false"] 
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
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForRelatedVideosWithURL:safeSearch:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForRelatedVideosWithURL$safeSearch$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForRelatedVideosWithURL$safeSearch$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForRelatedVideosWithURL:safeSearch:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForRelatedVideosWithURL:safeSearch:count:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$count$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForRelatedVideosWithURL$safeSearch$count$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeRelatedVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeRelatedVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeRelatedVideosRequest$responseBlock$errorBlock$);}} }
#line 71 "googleapp/suggestedvideos.x"
