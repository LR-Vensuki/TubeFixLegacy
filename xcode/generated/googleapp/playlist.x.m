#line 1 "googleapp/playlist.x"





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

@class YTGDataService; @class YTGDataRequest; @class YTGDataRequestFactory; @class YTVideoListView; @class YTPlaylistParser; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForPlaylistsWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForPlaylistVideosWithURL$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistVideosWithURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyPlaylistVideosWithURL$authentication$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPlaylistVideosWithURL$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToWatchLaterWithVideoID$authentication$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToWatchLaterWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToPlaylistWithVideoID$contentURL$auth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToPlaylistWithVideoID$contentURL$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddPlaylistWithTitle$description$isPrivate$auth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, NSString*, BOOL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddPlaylistWithTitle$description$isPrivate$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, NSString*, BOOL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithChannelID$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithURL$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithURL$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyPlaylistVideosWithURL$authentication$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPlaylistVideosWithURL$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToWatchLaterWithVideoID$authentication$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToWatchLaterWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToPlaylistWithVideoID$contentURL$auth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToPlaylistWithVideoID$contentURL$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddPlaylistWithTitle$description$isPrivate$auth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, BOOL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddPlaylistWithTitle$description$isPrivate$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, BOOL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithPlaylistID$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithPlaylistID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyPlaylistsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyPlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makePlaylistsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makePlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makePlaylistVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makePlaylistVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyPlaylistVideosRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyPlaylistVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makePlaylistRequestWithPlaylistID$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static void _logos_method$_ungrouped$YTGDataService$makePlaylistRequestWithPlaylistID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id (*_logos_orig$_ungrouped$YTPlaylistParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTPlaylistParser* _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError *); static id _logos_method$_ungrouped$YTPlaylistParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTPlaylistParser* _LOGOS_SELF_CONST, SEL, NSDictionary*, NSError *); static void (*_logos_orig$_ungrouped$YTVideoListView$setVideoCount$)(_LOGOS_SELF_TYPE_NORMAL YTVideoListView* _LOGOS_SELF_CONST, SEL, int); static void _logos_method$_ungrouped$YTVideoListView$setVideoCount$(_LOGOS_SELF_TYPE_NORMAL YTVideoListView* _LOGOS_SELF_CONST, SEL, int); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 14 "googleapp/playlist.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id channelId) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EglwbGF5bGlzdHPyBgQKAkIA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistVideosWithURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPlaylistVideosWithURL$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId, id authentication) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToWatchLaterWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse/edit_playlist?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder addVideoToPlaylistBodyWithVideoIds:@[videoId] 
                                                            playlistId:@"WL" 
                                                            client:[YoutubeClientType webMobileClient]]];
}


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToPlaylistWithVideoID$contentURL$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id contentURL, id authentication) {
  return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse/edit_playlist?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder addVideoToPlaylistBodyWithVideoIds:@[videoId] 
                                                            playlistId:contentURL
                                                            client:[YoutubeClientType webMobileClient]]];
}



static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToAddPlaylistWithTitle$description$isPrivate$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* title, NSString* description, BOOL isPrivate, id authentication) {
    NSString *visibilityType = @"PUBLIC";
    if (isPrivate) {
        visibilityType = @"PRIVATE";
    }
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/playlist/create?prettyPrint=false"] 
                 authentication:authentication
                           body:[TRRequestBuilder createPlaylistWithTitle:title
                                                            description:description
                                                            visibilityType:visibilityType
                                                            client:[YoutubeClientType webMobileClient]]];
}






static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithChannelID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id channelId) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:channelId 
                                                            params:@"EglwbGF5bGlzdHPyBgQKAkIA" 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithURL$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPlaylistVideosWithURL$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId, id authentication) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToWatchLaterWithVideoID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id authentication) {
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse/edit_playlist?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder addVideoToPlaylistBodyWithVideoIds:@[videoId] 
                                                            playlistId:@"WL" 
                                                            client:[YoutubeClientType webMobileClient]]];
}


static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToPlaylistWithVideoID$contentURL$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, id contentURL, id authentication) {
  return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse/edit_playlist?prettyPrint=false"] 
                 authentication:authentication 
                           body:[TRRequestBuilder addVideoToPlaylistBodyWithVideoIds:@[videoId] 
                                                            playlistId:contentURL
                                                            client:[YoutubeClientType webMobileClient]]];
}


static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToAddPlaylistWithTitle$description$isPrivate$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* title, NSString* description, BOOL isPrivate, id authentication) {
    NSString *visibilityType = @"PUBLIC";
    if (isPrivate) {
        visibilityType = @"PRIVATE";
    }
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/playlist/create?prettyPrint=false"] 
                 authentication:authentication
                           body:[TRRequestBuilder createPlaylistWithTitle:title
                                                            description:description
                                                            visibilityType:visibilityType
                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithPlaylistID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}


#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeMyPlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    
    id actualRequest = nil;
    if ([[request valueForKey:l(@"URL")] isKindOfClass:[TRContinuation class]]) {
        TRContinuation *continuation = [request valueForKey:l(@"URL")];
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        }
        
    } else {
        NSData *body = [TRRequestBuilder browseBodyWithId:[[request authentication] channelID] 
                                               params:@"EglwbGF5bGlzdHPyBgQKAkIA" 
                                               client:[YoutubeClientType webMobileClient]];
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:body];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                    authentication:nil 
                            body:body];
        }
    }    
    
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"playlistPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makePlaylistsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    if ([[request valueForKey:l(@"URL")] isKindOfClass:[TRContinuation class]]) {
        TRContinuation *continuation = [request valueForKey:l(@"URL")];
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            actualRequest = [_logos_static_class_lookup$YTGDataRequest() requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        } else {
            actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                authentication:nil 
                body:[TRRequestBuilder continueWithContext:[continuation token]
                        client:[YoutubeClientType webMobileClient]]];
        }
        
    }
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"playlistPageParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}

static void _logos_method$_ungrouped$YTGDataService$makePlaylistVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
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

static void _logos_method$_ungrouped$YTGDataService$makeMyPlaylistVideosRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
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

static void _logos_method$_ungrouped$YTGDataService$makePlaylistRequestWithPlaylistID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* playlistId, id responseBlock, id errorBlock) {
    NSString *browseId = [NSString stringWithFormat:@"VL%@", playlistId];
    id actualRequest = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"] 
                        authentication:nil
                                body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"playlistParser")] 
            responseBlock:responseBlock 
               errorBlock:errorBlock];
}


#pragma mark - Playlist Parsing

 

static id _logos_method$_ungrouped$YTPlaylistParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTPlaylistParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary* body, NSError * error) {
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        TRPlaylistTranslator *translator = [[[TRPlaylistTranslator alloc] init] autorelease];
        NSError *translatorError = nil;
        id playlist = [translator translateJSON:body error:&translatorError];
        
        if (translatorError) {
            NSLog(@"TRPlaylistTranslator error: %@", translatorError);
        }
        
        return playlist;
    }
    
    NSLog(@"YTPlaylistParser: input is not NSDictionary");
    return nil;
}





static void _logos_method$_ungrouped$YTVideoListView$setVideoCount$(_LOGOS_SELF_TYPE_NORMAL YTVideoListView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int videoCount) {
    if (videoCount == 2147483647) return;
    return _logos_orig$_ungrouped$YTVideoListView$setVideoCount$(self, _cmd, videoCount);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForPlaylistsWithChannelID:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistsWithChannelID$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForPlaylistsWithChannelID$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForPlaylistVideosWithURL:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForPlaylistVideosWithURL$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForPlaylistVideosWithURL$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyPlaylistVideosWithURL:authentication:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyPlaylistVideosWithURL$authentication$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyPlaylistVideosWithURL$authentication$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToAddToWatchLaterWithVideoID:authentication:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToWatchLaterWithVideoID$authentication$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToWatchLaterWithVideoID$authentication$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToAddToPlaylistWithVideoID:contentURL:auth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToAddToPlaylistWithVideoID$contentURL$auth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddToPlaylistWithVideoID$contentURL$auth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToAddPlaylistWithTitle:description:isPrivate:auth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToAddPlaylistWithTitle$description$isPrivate$auth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToAddPlaylistWithTitle$description$isPrivate$auth$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForPlaylistsWithChannelID:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithChannelID$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistsWithChannelID$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForPlaylistVideosWithURL:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithURL$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithURL$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyPlaylistVideosWithURL:authentication:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyPlaylistVideosWithURL$authentication$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyPlaylistVideosWithURL$authentication$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToAddToWatchLaterWithVideoID:authentication:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToWatchLaterWithVideoID$authentication$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToWatchLaterWithVideoID$authentication$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToAddToPlaylistWithVideoID:contentURL:auth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToAddToPlaylistWithVideoID$contentURL$auth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddToPlaylistWithVideoID$contentURL$auth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToAddPlaylistWithTitle:description:isPrivate:auth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToAddPlaylistWithTitle$description$isPrivate$auth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToAddPlaylistWithTitle$description$isPrivate$auth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForPlaylistVideosWithPlaylistID:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithPlaylistID$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForPlaylistVideosWithPlaylistID$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyPlaylistsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyPlaylistsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyPlaylistsRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makePlaylistsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makePlaylistsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makePlaylistsRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makePlaylistVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makePlaylistVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makePlaylistVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyPlaylistVideosRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyPlaylistVideosRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyPlaylistVideosRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makePlaylistRequestWithPlaylistID:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makePlaylistRequestWithPlaylistID$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makePlaylistRequestWithPlaylistID$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTPlaylistParser = objc_getClass("YTPlaylistParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlaylistParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTPlaylistParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTPlaylistParser$parseElement$error$);}Class _logos_class$_ungrouped$YTVideoListView = objc_getClass("YTVideoListView"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoListView, @selector(setVideoCount:), (IMP)&_logos_method$_ungrouped$YTVideoListView$setVideoCount$, (IMP*)&_logos_orig$_ungrouped$YTVideoListView$setVideoCount$);}} }
#line 300 "googleapp/playlist.x"
