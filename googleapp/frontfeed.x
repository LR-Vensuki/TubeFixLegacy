// frontfeed.x
// TubeFixLegacy
//
// Standard/category video feeds (front page, categories)

#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "general.h"
#include "TRShorts.h"

@interface YTGDataService (TFLFrontFeed)
-(id)tr_innertubeRequestWithURL:(NSURL*)url body:(NSData*)body;
@end

// The Shorts side-menu entry is a Shorts-only search (the "Shorts" type
// filter) - there's no browse ID that returns a plain list of Shorts.
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

%hook YTGDataService

%new
-(id)tr_innertubeRequestWithURL:(NSURL*)url body:(NSData*)body {
    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
        return [%c(YTGDataRequest) requestWithURL:url authentication:nil body:body];
    }
    return [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestWithURL:url authentication:nil body:body];
}

-(void)makeVideosStandardFeedRequest:(YTGDataRequest*)request responseBlock:(id)responseBlock errorBlock:(id)errorBlock {
    id actualRequest = request;
    id actualResponseBlock = responseBlock;
    BOOL isShortsFeed = NO;

    id requestURL = [request URL];
    if ([requestURL isKindOfClass:[NSString class]]) {
        // continuation of an earlier page
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
        // first page of the Shorts side-menu feed (see requestForVideosWithStandardFeed below)
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

%end

#pragma mark - Request Building

%hook YTGDataRequest

+(id)requestForVideosWithStandardFeed:(int)requestingForInt categoryTerm:(NSString*)category uploadDate:(int)uploadFilter safeSearch:(int)safeSearch {
    if (TRIsShortsCategoryTerm(category)) {
        return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyPrint=false"]
                     authentication:nil
                               body:TRShortsFeedRequestBody()];
    }

    // Map category to pre-defined playlist browse IDs
    // These are curated "trending" style playlists for each category
    NSString *browseId = @""; // default
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
        // trending
        if (preferences[@"TrendingBrowseId"]) {
            browseId = preferences[@"TrendingBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi2AsCiyuafMeQrMF6czMoL";
        }
    }
    
    GTMURLBuilder *urlBuilder = [%c(GTMURLBuilder) builderWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"];
    NSURL *fullURL = [urlBuilder URL];
    
    return [self requestWithURL:fullURL 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

%end


%hook YTGDataRequestFactory

-(id)requestForVideosWithStandardFeed:(int)requestingForInt categoryTerm:(NSString*)category uploadDate:(int)uploadFilter safeSearch:(int)safeSearch {
    if (TRIsShortsCategoryTerm(category)) {
        return [self requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyPrint=false"]
                     authentication:nil
                               body:TRShortsFeedRequestBody()];
    }

    // Map category to pre-defined playlist browse IDs
    // These are curated "trending" style playlists for each category
    NSString *browseId = @""; // default
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
        // trending
        if (preferences[@"TrendingBrowseId"]) {
            browseId = preferences[@"TrendingBrowseId"];
        } else {
            browseId = @"VLPL-p0-Yh03xpi2AsCiyuafMeQrMF6czMoL";
        }
    }
    
    GTMURLBuilder *urlBuilder = [%c(GTMURLBuilder) builderWithString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"];
    NSURL *fullURL = [urlBuilder URL];
    
    return [self requestWithURL:fullURL 
                 authentication:nil 
                           body:[TRRequestBuilder browseBodyWithId:browseId 
                                                            params:nil 
                                                            client:[YoutubeClientType webMobileClient]]];
}

%end
