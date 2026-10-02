#line 1 "googleapp/frontfeed.x"





#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "general.h"
#include "TRShorts.h"

@interface YTGDataService (TFLFrontFeed)
-(id)tr_innertubeRequestWithURL:(NSURL*)url body:(NSData*)body;
@end



static NSData *TRShortsFeedRequestBody(void) {
    return [TRRequestBuilder searchBodyWithQuery:TRShortsQuery()
                                            type:TR_SHORTS_SEARCH_TYPE
                                          sortBy:0
                                        duration:0
                                           hasCC:NO
                                          posted:0
                                          client:[YoutubeClientType webMobileClient]];
}

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

@class YTGDataRequest; @class YTGDataService; @class YTGDataRequestFactory; @class GTMURLBuilder; 
static id _logos_method$_ungrouped$YTGDataService$tr_innertubeRequestWithURL$body$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSURL*, NSData*); static void (*_logos_orig$_ungrouped$YTGDataService$makeVideosStandardFeedRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeVideosStandardFeedRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest*, id, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, NSString*, int, int); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, NSString*, int, int); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, int, NSString*, int, int); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, int, NSString*, int, int); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GTMURLBuilder(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GTMURLBuilder"); } return _klass; }
#line 30 "googleapp/frontfeed.x"



static id _logos_method$_ungrouped$YTGDataService$tr_innertubeRequestWithURL$body$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL* url, NSData* body) {
    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
        return [_logos_static_class_lookup$YTGDataRequest() requestWithURL:url authentication:nil body:body];
    }
    return [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:url authentication:nil body:body];
}

static void _logos_method$_ungrouped$YTGDataService$makeVideosStandardFeedRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest* request, id responseBlock, id errorBlock) {
    id actualRequest = request;
    id actualResponseBlock = responseBlock;
    BOOL isShortsFeed = NO;

    id requestURL = [request URL];
    if ([requestURL isKindOfClass:[NSString class]]) {
        
        NSString *token = requestURL;
        NSString *endpoint = @"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false";
        if ([token hasPrefix:TR_SHORTS_CONTINUATION_PREFIX]) {
            token = [token substringFromIndex:[TR_SHORTS_CONTINUATION_PREFIX length]];
            endpoint = @"https://www.youtube.com/youtubei/v1/search?prettyPrint=false";
            isShortsFeed = YES;
        }
        actualRequest = [self tr_innertubeRequestWithURL:[NSURL URLWithString:endpoint]
                                                    body:[TRRequestBuilder continueWithContext:token
                                                                                        client:[YoutubeClientType webMobileClient]]];
    } else if ([requestURL isKindOfClass:[NSURL class]] && [[requestURL path] hasSuffix:@"/search"]) {
        
        isShortsFeed = YES;
    }

    if (isShortsFeed) {
        TFLLog(@"Shorts feed request: %@", requestURL);
        void (^originalResponseBlock)(id) = [[responseBlock copy] autorelease];
        actualResponseBlock = [[^(id page) {
            TRShortsPreparePage(page);
            TRMarkShortsCategoryPage(page);
            TFLLog(@"Shorts page: %@", page);
            if (originalResponseBlock) {
                originalResponseBlock(page);
            }
        } copy] autorelease];
        if (TRVerboseLogging()) {
            void (^originalErrorBlock)(id) = [[errorBlock copy] autorelease];
            errorBlock = [[^(id error) {
                TFLLog(@"Shorts feed error: %@", error);
                if (originalErrorBlock) {
                    originalErrorBlock(error);
                }
            } copy] autorelease];
        }
    }

    [self makePOSTRequest:actualRequest 
               withParser:[self valueForKey:l(@"videoPageParser")] 
            responseBlock:actualResponseBlock 
               errorBlock:errorBlock];
}



#pragma mark - Request Building



static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int requestingForInt, NSString* category, int uploadFilter, int safeSearch) {
    if (TRIsShortsCategoryTerm(category)) {
        return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyPrint=false"]
                     authentication:nil
                               body:TRShortsFeedRequestBody()];
    }

    
    
    NSString *browseId = @""; 
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];

    if ([category isEqualToString:@"Games"]) {
        if (preferences[@"GamesBrowseId"]) {
            browseId = preferences[@"GamesBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi_x9L-Lqop_Kj6MTY38jqv";
        }
    } else if ([category isEqualToString:@"Film"]) {
        if (preferences[@"FilmBrowseId"]) {
            browseId = preferences[@"FilmBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgQgBqDn3T4EZbxoaYXkQjY";
        }
    } else if ([category isEqualToString:@"Autos"]) {
        if (preferences[@"AutosBrowseId"]) {
            browseId = preferences[@"AutosBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphS0WmPB1u5mQbRJjPRn63U";
        }
    } else if ([category isEqualToString:@"Music"]) {
        if (preferences[@"MusicBrowseId"]) {
            browseId = preferences[@"MusicBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgeN91B_sPpv4lJY-UfThEi";
        }
    } else if ([category isEqualToString:@"Animals"]) {
        if (preferences[@"AnimalsBrowseId"]) {
            browseId = preferences[@"AnimalsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgqRqXBDc9DbcCysUjd_CSB";
        }
    } else if ([category isEqualToString:@"Sports"]) {
        if (preferences[@"SportsBrowseId"]) {
            browseId = preferences[@"SportsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpg6CLD7MDqzsAiB9aFjssWb";
        }
    } else if ([category isEqualToString:@"Comedy"]) {
        if (preferences[@"ComedyBrowseId"]) {
            browseId = preferences[@"ComedyBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpj0Js3pnGO20BWWiHVn1oHz";
        }
    } else if ([category isEqualToString:@"People"]) {
        if (preferences[@"PeopleBrowseId"]) {
            browseId = preferences[@"PeopleBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphi7-iBuIshu7olymbv7lY-";
        }
    } else if ([category isEqualToString:@"News"]) {
        if (preferences[@"NewsBrowseId"]) {
            browseId = preferences[@"NewsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgeG3YUmWESSrg84W8ELEUO";
        }
    } else if ([category isEqualToString:@"Entertainment"]) {
        if (preferences[@"EntertainmentBrowseId"]) {
            browseId = preferences[@"EntertainmentBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpjoqDAI46lgo8-TLDnE7mHF";
        }
    } else if ([category isEqualToString:@"Howto"]) {
        if (preferences[@"HowtoBrowseId"]) {
            browseId = preferences[@"HowtoBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphCxNSaXOW09V3pKgRQCFvn";
        }
    } else if ([category isEqualToString:@"Tech"]) {
        if (preferences[@"TechBrowseId"]) {
            browseId = preferences[@"TechBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgQgBqDn3T4EZbxoaYXkQjY";
        }
    } else if ([category isEqualToString:@"Travel"]) {
        if (preferences[@"TravelBrowseId"]) {
            browseId = preferences[@"TravelBrowseId"];
        } else {
            browseId = @"";
        }
    } else if ([category isEqualToString:@"Education"]) {
        if (preferences[@"EducationBrowseId"]) {
            browseId = preferences[@"EducationBrowseId"];
        } else {
            browseId = @"";
        }
    } else if ([category isEqualToString:@"Nonprofit"]) {
        if (preferences[@"NonprofitBrowseId"]) {
            browseId = preferences[@"NonprofitBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphnE3_KKGzkbmGNPqKF8rXp";
        }
    } else {
        
        if (preferences[@"TrendingBrowseId"]) {
            browseId = preferences[@"TrendingBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi2AsCiyuafMeQrMF6czMoL";
        }
    }
    
    GTMURLBuilder *urlBuilder = [_logos_static_class_lookup$GTMURLBuilder() builderWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"];
    NSURL *fullURL = [urlBuilder URL];
    
    return [self requestWithURL:fullURL 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}






static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int requestingForInt, NSString* category, int uploadFilter, int safeSearch) {
    if (TRIsShortsCategoryTerm(category)) {
        return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyPrint=false"]
                     authentication:nil
                               body:TRShortsFeedRequestBody()];
    }

    
    
    NSString *browseId = @""; 
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];

    if ([category isEqualToString:@"Games"]) {
        if (preferences[@"GamesBrowseId"]) {
            browseId = preferences[@"GamesBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi_x9L-Lqop_Kj6MTY38jqv";
        }
    } else if ([category isEqualToString:@"Film"]) {
        if (preferences[@"FilmBrowseId"]) {
            browseId = preferences[@"FilmBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgQgBqDn3T4EZbxoaYXkQjY";
        }
    } else if ([category isEqualToString:@"Autos"]) {
        if (preferences[@"AutosBrowseId"]) {
            browseId = preferences[@"AutosBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphS0WmPB1u5mQbRJjPRn63U";
        }
    } else if ([category isEqualToString:@"Music"]) {
        if (preferences[@"MusicBrowseId"]) {
            browseId = preferences[@"MusicBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgeN91B_sPpv4lJY-UfThEi";
        }
    } else if ([category isEqualToString:@"Animals"]) {
        if (preferences[@"AnimalsBrowseId"]) {
            browseId = preferences[@"AnimalsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgqRqXBDc9DbcCysUjd_CSB";
        }
    } else if ([category isEqualToString:@"Sports"]) {
        if (preferences[@"SportsBrowseId"]) {
            browseId = preferences[@"SportsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpg6CLD7MDqzsAiB9aFjssWb";
        }
    } else if ([category isEqualToString:@"Comedy"]) {
        if (preferences[@"ComedyBrowseId"]) {
            browseId = preferences[@"ComedyBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpj0Js3pnGO20BWWiHVn1oHz";
        }
    } else if ([category isEqualToString:@"People"]) {
        if (preferences[@"PeopleBrowseId"]) {
            browseId = preferences[@"PeopleBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphi7-iBuIshu7olymbv7lY-";
        }
    } else if ([category isEqualToString:@"News"]) {
        if (preferences[@"NewsBrowseId"]) {
            browseId = preferences[@"NewsBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgeG3YUmWESSrg84W8ELEUO";
        }
    } else if ([category isEqualToString:@"Entertainment"]) {
        if (preferences[@"EntertainmentBrowseId"]) {
            browseId = preferences[@"EntertainmentBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpjoqDAI46lgo8-TLDnE7mHF";
        }
    } else if ([category isEqualToString:@"Howto"]) {
        if (preferences[@"HowtoBrowseId"]) {
            browseId = preferences[@"HowtoBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xphCxNSaXOW09V3pKgRQCFvn";
        }
    } else if ([category isEqualToString:@"Tech"]) {
        if (preferences[@"TechBrowseId"]) {
            browseId = preferences[@"TechBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpgQgBqDn3T4EZbxoaYXkQjY";
        }
    } else if ([category isEqualToString:@"Travel"]) {
        if (preferences[@"TravelBrowseId"]) {
            browseId = preferences[@"TravelBrowseId"];
        } else {
            browseId = @"";
        }
    } else if ([category isEqualToString:@"Education"]) {
        if (preferences[@"EducationBrowseId"]) {
            browseId = preferences[@"EducationBrowseId"];
        } else {
            browseId = @"";
        }
    } else if ([category isEqualToString:@"Nonprofit"]) {
        if (preferences[@"NonprofitBrowseId"]) {
            browseId = preferences[@"NonprofitBrowseId"];
        } else {
            browseId = @"";
        }
    } else {
        
        if (preferences[@"TrendingBrowseId"]) {
            browseId = preferences[@"TrendingBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi2AsCiyuafMeQrMF6czMoL";
        }
    }
    
    GTMURLBuilder *urlBuilder = [_logos_static_class_lookup$GTMURLBuilder() builderWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"];
    NSURL *fullURL = [urlBuilder URL];
    
    return [self requestWithURL:fullURL 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSURL*), strlen(@encode(NSURL*))); i += strlen(@encode(NSURL*)); memcpy(_typeEncoding + i, @encode(NSData*), strlen(@encode(NSData*))); i += strlen(@encode(NSData*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTGDataService, @selector(tr_innertubeRequestWithURL:body:), (IMP)&_logos_method$_ungrouped$YTGDataService$tr_innertubeRequestWithURL$body$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeVideosStandardFeedRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeVideosStandardFeedRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeVideosStandardFeedRequest$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForVideosWithStandardFeed:categoryTerm:uploadDate:safeSearch:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForVideosWithStandardFeed:categoryTerm:uploadDate:safeSearch:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForVideosWithStandardFeed$categoryTerm$uploadDate$safeSearch$);}} }
#line 345 "googleapp/frontfeed.x"
