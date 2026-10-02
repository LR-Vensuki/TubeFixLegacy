// TRShorts.m
// TubeFixLegacy

#import "TRShorts.h"
#import <objc/runtime.h>
#import "general.h"
#import "Translators/TRJSONUtils.h"
#import "appheaders.h"

static const char kTRShortsPortraitThumbnailKey;

BOOL TRIsShortsCategoryTerm(NSString *term) {
    return [term isKindOfClass:[NSString class]] && [term isEqualToString:TR_SHORTS_CATEGORY_TERM];
}

static void TRAddCountryCode(NSMutableArray *countries, id code) {
    if ([code isKindOfClass:[NSString class]] && [code length] > 0) {
        NSString *lowercase = [code lowercaseString];
        if (![countries containsObject:lowercase]) {
            [countries addObject:lowercase];
        }
    }
}

NSArray *TRGuideBrowsableCountries(void) {
    static NSArray *countries = nil;
    if (!countries) {
        NSMutableArray *list = [NSMutableArray arrayWithObjects:@"ar", @"au", @"bd", @"be", @"bg", @"br", @"ca", @"cl", @"co", @"cz", @"de", @"dk", @"dz", @"ee", @"eg", @"es", @"et", @"fi", @"fr", @"gb", @"gr", @"hk", @"hr", @"hu", @"id", @"ie", @"il", @"in", @"ir", @"is", @"it", @"jo", @"jp", @"ke", @"kr", @"lt", @"lv", @"ma", @"mx", @"my", @"ng", @"nl", @"no", @"nz", @"ph", @"pk", @"pl", @"pt", @"ro", @"rs", @"ru", @"sa", @"se", @"sg", @"si", @"sk", @"th", @"tn", @"tr", @"tw", @"tz", @"ua", @"ug", @"us", @"vn", @"ye", @"za", nil];
        // the guide compares against the user's own country, which may not
        // be in the list above (e.g. by, kz) - always include it
        TRAddCountryCode(list, [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]);
        Class utils = NSClassFromString(@"YTUtils") ?: NSClassFromString(@"YTDataUtils");
        if ([utils respondsToSelector:@selector(userCountryCode)]) {
            TRAddCountryCode(list, [utils userCountryCode]);
        }
        countries = [list copy];
    }
    return countries;
}

void TRShortsPreparePage(id page) {
    if (!page || ![page respondsToSelector:@selector(nextURL)]) {
        return;
    }
    @try {
        id nextURL = [page nextURL];
        if ([nextURL isKindOfClass:[NSString class]] && ![nextURL hasPrefix:TR_SHORTS_CONTINUATION_PREFIX]) {
            [page setValue:[TR_SHORTS_CONTINUATION_PREFIX stringByAppendingString:nextURL] forKey:l(@"nextURL")];
        }
    } @catch (NSException *exception) {
        NSLog(@"[TubeFixLegacy] couldn't prepare Shorts page: %@", exception);
    }
}

static BOOL TRVideoRendererOpensShorts(NSDictionary *renderer) {
    if (![renderer isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([TRJSONUtils dictFromJSON:renderer keyPath:@"navigationEndpoint.reelWatchEndpoint"]) {
        return YES;
    }
    NSString *url = [TRJSONUtils stringFromJSON:renderer keyPath:@"navigationEndpoint.commandMetadata.webCommandMetadata.url"];
    return [url hasPrefix:@"/shorts/"];
}

BOOL TRJSONItemIsShort(NSDictionary *item) {
    if (![item isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (item[@"shortsLockupViewModel"] || item[@"reelItemRenderer"]) {
        return YES;
    }
    NSDictionary *content = [TRJSONUtils dictFromJSON:item keyPath:@"richItemRenderer.content"];
    if (content[@"shortsLockupViewModel"] || content[@"reelItemRenderer"]) {
        return YES;
    }
    for (NSString *key in @[@"videoWithContextRenderer", @"videoRenderer", @"compactVideoRenderer"]) {
        if (TRVideoRendererOpensShorts(item[key]) || TRVideoRendererOpensShorts(content[key])) {
            return YES;
        }
    }
    return NO;
}

NSArray *TRJSONShortsShelfItems(NSDictionary *item) {
    if (![item isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    static NSArray *shelfKeyPaths = nil;
    if (!shelfKeyPaths) {
        shelfKeyPaths = [[NSArray alloc] initWithObjects:
            @"gridShelfViewModel.contents",                               // search
            @"reelShelfRenderer.items",                                   // browse / older search
            @"richItemRenderer.content.reelShelfRenderer.items",          // home grid
            @"richSectionRenderer.content.richShelfRenderer.contents",    // home / subscriptions grid
            @"richSectionRenderer.content.reelShelfRenderer.items",
            @"itemSectionRenderer.contents[0].reelShelfRenderer.items",
            nil];
    }

    for (NSString *keyPath in shelfKeyPaths) {
        NSArray *shelfItems = [TRJSONUtils arrayFromJSON:item keyPath:keyPath];
        if (![shelfItems isKindOfClass:[NSArray class]] || [shelfItems count] == 0) {
            continue;
        }
        // only a shelf *of Shorts* counts - richShelfRenderer is also used
        // for ordinary video shelves (news, etc.)
        for (NSDictionary *shelfItem in shelfItems) {
            if (TRJSONItemIsShort(shelfItem)) {
                return shelfItems;
            }
        }
    }
    return nil;
}

void TRSetShortsPortraitThumbnail(id video, NSURL *url) {
    if (video && url) {
        objc_setAssociatedObject(video, &kTRShortsPortraitThumbnailKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

NSURL *TRShortsPortraitThumbnail(id video) {
    return video ? objc_getAssociatedObject(video, &kTRShortsPortraitThumbnailKey) : nil;
}

#pragma mark - Which videos are Shorts, and in what order they came

@protocol TRShortsVideoMessages
- (NSString *)ID;
- (NSString *)title;
- (NSString *)uploaderDisplayName;
- (NSString *)uploaderChannelID;
- (unsigned long long)viewCount;
@end

static const char kTRIsShortKey;
static NSMutableArray *gTRShortsBatches = nil;  // of NSMutableArray of info dictionaries
static NSMutableSet *gTRShortVideoIDs = nil;
static CFAbsoluteTime gTRShortsLastRegistration = 0;

// a feed page is translated in one tight loop; anything further apart is
// another page (or another feed)
static const CFAbsoluteTime kTRShortsBatchGap = 1.5;

static id TRShortsSafeMessage(id object, SEL selector) {
    if (![object respondsToSelector:selector]) return nil;
    id value = [object performSelector:selector];
    return [value isKindOfClass:[NSString class]] && [value length] > 0 ? value : nil;
}

static id TRShortsLock(void) {
    static id lock = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        lock = [[NSObject alloc] init];
    });
    return lock;
}

static NSURL *TRFallbackShortThumbnail(NSString *videoID) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/hqdefault.jpg", videoID]];
}

void TRRegisterShortVideo(id video, NSURL *portraitThumbnail) {
    NSString *videoID = TRShortsSafeMessage(video, @selector(ID));
    if (!videoID) {
        return;
    }
    objc_setAssociatedObject(video, &kTRIsShortKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:videoID forKey:TR_SHORT_VIDEO_ID];
    NSString *title = TRShortsSafeMessage(video, @selector(title));
    NSString *author = TRShortsSafeMessage(video, @selector(uploaderDisplayName));
    NSString *channelID = TRShortsSafeMessage(video, @selector(uploaderChannelID));
    if (title) [info setObject:title forKey:TR_SHORT_TITLE];
    if (author) [info setObject:author forKey:TR_SHORT_AUTHOR];
    if (channelID) [info setObject:channelID forKey:TR_SHORT_CHANNEL_ID];
    if ([video respondsToSelector:@selector(viewCount)]) {
        [info setObject:[NSNumber numberWithUnsignedLongLong:[(id<TRShortsVideoMessages>)video viewCount]] forKey:TR_SHORT_VIEWS];
    }
    [info setObject:(portraitThumbnail ?: TRFallbackShortThumbnail(videoID)) forKey:TR_SHORT_THUMBNAIL];

    @synchronized (TRShortsLock()) {
        if (!gTRShortsBatches) {
            gTRShortsBatches = [[NSMutableArray alloc] init];
            gTRShortVideoIDs = [[NSMutableSet alloc] init];
        }
        [gTRShortVideoIDs addObject:videoID];
        CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        NSMutableArray *batch = [gTRShortsBatches lastObject];
        if (!batch || now - gTRShortsLastRegistration > kTRShortsBatchGap || [batch count] >= 300) {
            batch = [NSMutableArray array];
            [gTRShortsBatches addObject:batch];
            if ([gTRShortsBatches count] > 12) {
                [gTRShortsBatches removeObjectAtIndex:0];
            }
        }
        gTRShortsLastRegistration = now;
        for (NSDictionary *existing in batch) {
            if ([[existing objectForKey:TR_SHORT_VIDEO_ID] isEqualToString:videoID]) {
                return;
            }
        }
        [batch addObject:info];
    }
}

BOOL TRIsKnownShortVideoID(NSString *videoID) {
    if (![videoID isKindOfClass:[NSString class]]) return NO;
    @synchronized (TRShortsLock()) {
        return [gTRShortVideoIDs containsObject:videoID];
    }
}

BOOL TRVideoIsShort(id video) {
    if (!video) return NO;
    if ([objc_getAssociatedObject(video, &kTRIsShortKey) boolValue]) return YES;
    return TRIsKnownShortVideoID(TRShortsSafeMessage(video, @selector(ID)));
}

NSArray *TRShortsSequenceAround(NSString *videoID, NSUInteger *index) {
    if (![videoID isKindOfClass:[NSString class]]) return nil;
    @synchronized (TRShortsLock()) {
        for (NSArray *batch in [gTRShortsBatches reverseObjectEnumerator]) {
            for (NSUInteger i = 0; i < [batch count]; i++) {
                if ([[[batch objectAtIndex:i] objectForKey:TR_SHORT_VIDEO_ID] isEqualToString:videoID]) {
                    if (index) *index = i;
                    return [[batch copy] autorelease];
                }
            }
        }
    }
    return nil;
}

static NSString *TRShortsText(NSDictionary *json, NSArray *keyPaths) {
    for (NSString *keyPath in keyPaths) {
        NSString *text = [TRJSONUtils stringFromJSON:json keyPath:keyPath];
        if ([text isKindOfClass:[NSString class]] && [text length] > 0) {
            return text;
        }
    }
    return nil;
}

static uint64_t TRShortsCountFromText(NSString *text) {
    if (![text isKindOfClass:[NSString class]]) return 0;
    NSString *cleaned = [[[text stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSScanner *scanner = [NSScanner scannerWithString:cleaned];
    double number = 0;
    if (![scanner scanDouble:&number]) return 0;
    NSString *suffix = [[[cleaned substringFromIndex:[scanner scanLocation]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    if ([suffix hasPrefix:@"K"]) number *= 1e3;
    else if ([suffix hasPrefix:@"M"]) number *= 1e6;
    else if ([suffix hasPrefix:@"B"]) number *= 1e9;
    return (uint64_t)llround(number);
}

NSDictionary *TRShortInfoFromJSONItem(NSDictionary *item) {
    if (!TRJSONItemIsShort(item)) {
        return nil;
    }
    NSDictionary *content = [TRJSONUtils dictFromJSON:item keyPath:@"richItemRenderer.content"] ?: item;
    NSString *videoID = nil, *title = nil, *author = nil, *channelID = nil, *viewsText = nil;
    NSArray *thumbnails = nil;

    NSDictionary *lockup = [content objectForKey:@"shortsLockupViewModel"];
    NSDictionary *reel = [content objectForKey:@"reelItemRenderer"];
    if ([lockup isKindOfClass:[NSDictionary class]]) {
        videoID = [TRJSONUtils stringFromJSON:lockup keyPath:@"onTap.innertubeCommand.reelWatchEndpoint.videoId"];
        NSString *entityID = [lockup objectForKey:@"entityId"];
        if (!videoID && [entityID isKindOfClass:[NSString class]] && [entityID hasPrefix:@"shorts-shelf-item-"]) {
            videoID = [entityID substringFromIndex:[@"shorts-shelf-item-" length]];
        }
        title = TRShortsText(lockup, @[@"overlayMetadata.primaryText.content", @"accessibilityText"]);
        viewsText = TRShortsText(lockup, @[@"overlayMetadata.secondaryText.content"]);
        thumbnails = [TRJSONUtils arrayFromJSON:lockup keyPath:@"thumbnail.sources"];
    } else if ([reel isKindOfClass:[NSDictionary class]]) {
        videoID = [reel objectForKey:@"videoId"];
        title = TRShortsText(reel, @[@"headline.simpleText", @"headline.runs[0].text"]);
        viewsText = TRShortsText(reel, @[@"viewCountText.simpleText", @"viewCountText.runs[0].text"]);
        thumbnails = [TRJSONUtils arrayFromJSON:reel keyPath:@"thumbnail.thumbnails"];
    } else {
        for (NSString *key in @[@"videoWithContextRenderer", @"videoRenderer", @"compactVideoRenderer"]) {
            NSDictionary *renderer = [content objectForKey:key];
            if (![renderer isKindOfClass:[NSDictionary class]]) continue;
            videoID = [renderer objectForKey:@"videoId"];
            title = TRShortsText(renderer, @[@"headline.runs[0].text", @"title.runs[0].text", @"title.simpleText", @"headline.simpleText"]);
            author = TRShortsText(renderer, @[@"shortBylineText.runs[0].text", @"longBylineText.runs[0].text", @"ownerText.runs[0].text"]);
            channelID = TRShortsText(renderer, @[@"shortBylineText.runs[0].navigationEndpoint.browseEndpoint.browseId", @"longBylineText.runs[0].navigationEndpoint.browseEndpoint.browseId"]);
            viewsText = TRShortsText(renderer, @[@"shortViewCountText.runs[0].text", @"shortViewCountText.simpleText", @"viewCountText.runs[0].text", @"viewCountText.simpleText"]);
            thumbnails = [TRJSONUtils arrayFromJSON:renderer keyPath:@"thumbnail.thumbnails"];
            break;
        }
    }
    if (![videoID isKindOfClass:[NSString class]] || [videoID length] == 0) {
        return nil;
    }

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:videoID forKey:TR_SHORT_VIDEO_ID];
    if (title) [info setObject:title forKey:TR_SHORT_TITLE];
    if (author) [info setObject:author forKey:TR_SHORT_AUTHOR];
    if (channelID) [info setObject:channelID forKey:TR_SHORT_CHANNEL_ID];
    if (viewsText) [info setObject:[NSNumber numberWithUnsignedLongLong:TRShortsCountFromText(viewsText)] forKey:TR_SHORT_VIEWS];
    NSURL *thumbnail = nil;
    NSDictionary *first = ([thumbnails isKindOfClass:[NSArray class]] && [thumbnails count] > 0) ? [thumbnails objectAtIndex:0] : nil;
    NSString *thumbnailString = [first isKindOfClass:[NSDictionary class]] ? [first objectForKey:@"url"] : nil;
    if ([thumbnailString isKindOfClass:[NSString class]]) {
        if ([thumbnailString hasPrefix:@"//"]) thumbnailString = [@"https:" stringByAppendingString:thumbnailString];
        thumbnail = [NSURL URLWithString:thumbnailString];
    }
    [info setObject:(thumbnail ?: TRFallbackShortThumbnail(videoID)) forKey:TR_SHORT_THUMBNAIL];
    return info;
}

#pragma mark - Collecting Shorts from any response

static void TRCollectShortsNode(id node, NSMutableArray *shorts, NSMutableSet *seen, NSString **continuation, int depth) {
    if (depth > 40) {
        return;
    }
    if ([node isKindOfClass:[NSDictionary class]]) {
        NSDictionary *info = TRShortInfoFromJSONItem(node);
        if (info) {
            NSString *videoID = [info objectForKey:TR_SHORT_VIDEO_ID];
            if (![seen containsObject:videoID]) {
                [seen addObject:videoID];
                [shorts addObject:info];
            }
            return;
        }
        NSDictionary *continuationItem = [(NSDictionary *)node objectForKey:@"continuationItemRenderer"];
        if ([continuationItem isKindOfClass:[NSDictionary class]]) {
            NSString *token = [TRJSONUtils stringFromJSON:continuationItem keyPath:@"continuationEndpoint.continuationCommand.token"];
            if (token && continuation) {
                *continuation = token;
            }
            return;
        }
        for (id value in [(NSDictionary *)node allValues]) {
            TRCollectShortsNode(value, shorts, seen, continuation, depth + 1);
        }
    } else if ([node isKindOfClass:[NSArray class]]) {
        for (id value in (NSArray *)node) {
            TRCollectShortsNode(value, shorts, seen, continuation, depth + 1);
        }
    }
}

void TRCollectShortsFromJSON(id json, NSMutableArray *shorts, NSString **continuation) {
    NSMutableSet *seen = [NSMutableSet set];
    for (NSDictionary *info in shorts) {
        id videoID = [info objectForKey:TR_SHORT_VIDEO_ID];
        if (videoID) [seen addObject:videoID];
    }
    TRCollectShortsNode(json, shorts, seen, continuation, 0);
}

#pragma mark - Side-menu Shorts feed

static NSMutableSet *gTRShortsCategoryIDs = nil;

void TRMarkShortsCategoryPage(id page) {
    NSArray *entries = [page respondsToSelector:@selector(entries)] ? [page performSelector:@selector(entries)] : nil;
    if (![entries isKindOfClass:[NSArray class]]) {
        return;
    }
    @synchronized (TRShortsLock()) {
        if (!gTRShortsCategoryIDs) {
            gTRShortsCategoryIDs = [[NSMutableSet alloc] init];
        }
        for (id entry in entries) {
            id video = [entry respondsToSelector:@selector(video)] ? [entry performSelector:@selector(video)] : entry;
            NSString *videoID = TRShortsSafeMessage(video, @selector(ID));
            if (videoID) {
                [gTRShortsCategoryIDs addObject:videoID];
            }
        }
    }
}

BOOL TRIsShortsCategoryVideoID(NSString *videoID) {
    if (![videoID isKindOfClass:[NSString class]]) return NO;
    @synchronized (TRShortsLock()) {
        return [gTRShortsCategoryIDs containsObject:videoID];
    }
}
