#line 1 "googleapp/search.x"





#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "Translators/TRContinuation.h"
#include "general.h"

@interface YTSearchFilters : NSObject {
    int sortBy_;
    int uploadDate_;
    int duration_;
    BOOL CC_;
}

- (void)setCC:(BOOL)cc;
- (BOOL)hasCC;
- (void)setDuration:(int)duration;
- (int)duration;
- (void)setUploadDate:(int)uploadDate;
- (int)uploadDate;
- (void)setSortBy:(int)sortBy;
- (int)sortBy;
- (id)copyWithZone:(struct _NSZone *)zone;

@end

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
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, NSString*, YTSearchFilters*, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, NSString*, YTSearchFilters*, NSString*); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForChannelsWithSearchQuery$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, YTSearchFilters*, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, YTSearchFilters*, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForChannelsWithSearchQuery$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithSearchQuery$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static void (*_logos_orig$_ungrouped$YTGDataService$makeSearchVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeSearchVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeSearchChannelsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeSearchChannelsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeSearchPlaylistsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeSearchPlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 33 "googleapp/search.x"





static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* query, NSString* language, YTSearchFilters* filters, NSString* safeSearchLevel) {

    int sortBy = 0;
    int uploadDate = 0;
    int duration = 0;

    switch ([filters sortBy]) {
        case 1: 
            sortBy = 2;
            break;
        case 2: 
            sortBy = 3;
            break;
        case 3: 
            sortBy = 1;
            break;
    }

    switch ([filters uploadDate]) {
        case 1: 
            uploadDate = 2;
            break;
        case 2: 
            uploadDate = 3;
            break;
        case 3: 
            uploadDate = 4;
            break;
    }


    switch ([filters duration]) {
        case 1: 
            duration = 1;
            break;
        case 2: 
            duration = 2;
            break;
    }
    NSLog(@"sortBy #2 -> %i", sortBy);

    id request = [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder searchBodyWithQuery:query 
                                                          type:1 
                                                          sortBy:sortBy
                                                          duration:duration
                                                          hasCC:[filters hasCC]
                                                          posted:uploadDate
                                                               client:[YoutubeClientType webMobileClient]]];
    return request;
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* query) {

    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder searchBodyWithQuery:query 
                                                          type:2 
                                                          sortBy:0
                                                          duration:0
                                                          hasCC:NO
                                                          posted:0
                                                               client:[YoutubeClientType webMobileClient]]];
}








static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* query, NSString* language, YTSearchFilters* filters, NSString* safeSearchLevel) {

    int sortBy = 0;
    int uploadDate = 0;
    int duration = 0;

    switch ([filters sortBy]) {
        case 1: 
            sortBy = 2;
            break;
        case 2: 
            sortBy = 3;
            break;
        case 3: 
            sortBy = 1;
            break;
    }

    switch ([filters uploadDate]) {
        case 1: 
            uploadDate = 2;
            break;
        case 2: 
            uploadDate = 3;
            break;
        case 3: 
            uploadDate = 4;
            break;
    }


    switch ([filters duration]) {
        case 1: 
            duration = 1;
            break;
        case 2: 
            duration = 2;
            break;
    }
    NSLog(@"sortBy #2 -> %i", sortBy);

    id request = [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder searchBodyWithQuery:query 
                                                          type:1 
                                                          sortBy:sortBy
                                                          duration:duration
                                                          hasCC:[filters hasCC]
                                                          posted:uploadDate
                                                               client:[YoutubeClientType webMobileClient]]];
    return request;
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* query) {

    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder searchBodyWithQuery:query 
                                                          type:2 
                                                          sortBy:0
                                                          duration:0
                                                          hasCC:NO
                                                          posted:0
                                                               client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithSearchQuery$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* query) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder searchBodyWithQuery:query 
                                                          type:3
                                                          sortBy:0
                                                          duration:0
                                                          hasCC:NO
                                                          posted:0
                                                               client:[YoutubeClientType webMobileClient]]];
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeSearchVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
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

static void _logos_method$_ungrouped$YTGDataService$makeSearchChannelsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[NSString class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                    authentication:nil 
                    body:[TRRequestBuilder continueWithContext:[request URL] 
                    client:[YoutubeClientType webMobileClient]]];
        }
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"channelPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makeSearchPlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request URL] isKindOfClass:[TRContinuation class]]) {
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                    authentication:nil 
                            body:[TRRequestBuilder continueWithContext:[request URL] 
                                                                client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyprint=false"] 
                    authentication:nil 
                    body:[TRRequestBuilder continueWithContext:[(TRContinuation*)[request URL] token]
                    client:[YoutubeClientType webMobileClient]]];
        }
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"playlistPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForVideosWithSearchQuery:languageCode:filters:safeSearch:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForChannelsWithSearchQuery:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelsWithSearchQuery$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForChannelsWithSearchQuery$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForVideosWithSearchQuery:languageCode:filters:safeSearch:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForVideosWithSearchQuery$languageCode$filters$safeSearch$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForChannelsWithSearchQuery:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelsWithSearchQuery$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForChannelsWithSearchQuery$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForPlaylistsWithSearchQuery:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithSearchQuery$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithSearchQuery$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeSearchVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeSearchVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeSearchVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeSearchChannelsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeSearchChannelsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeSearchChannelsRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeSearchPlaylistsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeSearchPlaylistsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeSearchPlaylistsRequest$responseBlock$errorBlock$);}} }
#line 260 "googleapp/search.x"
