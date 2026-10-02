#line 1 "googleapp/channelfeed.x"





#import <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "Translators/TRContinuation.h"
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
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForUploadedVideosWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForUploadedVideosWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForEventsWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForEventsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForUploadedVideosWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForUploadedVideosWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForEventsWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForEventsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static void (*_logos_orig$_ungrouped$YTGDataService$makeUploadedVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeUploadedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeEventsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeEventsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 14 "googleapp/channelfeed.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForUploadedVideosWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForEventsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURL:channelId
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForUploadedVideosWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForEventsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURL:channelId
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EgZ2aWRlb3PyBgQKAjoA" 
                                                            client:[YoutubeClientType webMobileClient]]];}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeUploadedVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
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


static void _logos_method$_ungrouped$YTGDataService$makeEventsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    id newResponseBlock = responseBlock;

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
    } else {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder getPopularVideosFromChannelId:[request URL]
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder getPopularVideosFromChannelId:[request URL]
                                                                client:[YoutubeClientType webMobileClient]]];
        }
        void (^originalResponseBlock)(id) = [responseBlock copy];
        void (^newResponseBlock)(id) = ^(id response) {
            [response setValue:nil forKey:l(@"nextURL")];
            for (YTEvent *event in [response entries]) {
                [event setValue:@5 forKey:l(@"action")];
                [event setValue:[request URL] forKey:l(@"authorUserID")];
                [event setValue:[[[self channelCache] objectForKey:[request URL]] displayName] forKey:l(@"authorDisplayName")];
                [[event video] setValue:[request URL] forKey:l(@"uploaderChannelID")];
                [[event video] setValue:[[[self channelCache] objectForKey:[request URL]] displayName] forKey:l(@"uploaderDisplayName")];
            }

            if (originalResponseBlock) {
                originalResponseBlock(response);
            }
        };

        [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"eventPageParser")] 
            responseBlock:newResponseBlock 
               errorBlock:errorBlock];

               return;
        
    }

    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"eventPageParser")] 
            responseBlock:newResponseBlock 
               errorBlock:errorBlock];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForUploadedVideosWithChannelID:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForUploadedVideosWithChannelID$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForUploadedVideosWithChannelID$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForEventsWithChannelID:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForEventsWithChannelID$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForEventsWithChannelID$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForUploadedVideosWithChannelID:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForUploadedVideosWithChannelID$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForUploadedVideosWithChannelID$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForEventsWithChannelID:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForEventsWithChannelID$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForEventsWithChannelID$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeUploadedVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeUploadedVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeUploadedVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeEventsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeEventsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeEventsRequest$responseBlock$errorBlock$);}} }
#line 139 "googleapp/channelfeed.x"
