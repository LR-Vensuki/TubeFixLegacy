#line 1 "googleapp/feeds.x"





#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "Translators/TRContinuation.h"
#include "general.h"

@interface YTPageParser : NSObject
+(id)parseLockupViewModelVideo:(NSDictionary*)unparsedVideo;


-(id)parseSpecializedFeed:(NSDictionary *)bodyDict  withEntryParser:(id)entryParser  error:(NSError **)error;
-(NSArray *)extractSpecializedItems:(NSDictionary *)bodyDict forParser:(id)parser;
@end


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

@class YTPageParser; @class YTVideoParser; @class YTPage; @class YTChannelParser; @class YTSubscriptionParser; @class YTPlaylistParser; @class YTEventParser; @class YTCommentParser; 
static id (*_logos_orig$_ungrouped$YTPageParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST, SEL, id, NSError **); static id _logos_method$_ungrouped$YTPageParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST, SEL, id, NSError **); static id _logos_method$_ungrouped$YTPageParser$parseSpecializedFeed$withEntryParser$error$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST, SEL, NSDictionary *, id, NSError **); static NSArray * _logos_method$_ungrouped$YTPageParser$extractSpecializedItems$forParser$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST, SEL, NSDictionary *, id); static id _logos_meta_method$_ungrouped$YTPageParser$parseLockupViewModelVideo$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSDictionary*); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTCommentParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTCommentParser"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTPlaylistParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTPlaylistParser"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTEventParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTEventParser"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTChannelParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTChannelParser"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTPage(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTPage"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTSubscriptionParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTSubscriptionParser"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTVideoParser(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTVideoParser"); } return _klass; }
#line 20 "googleapp/feeds.x"


#pragma mark - Main Entry Point

static id _logos_method$_ungrouped$YTPageParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id body, NSError ** error) {
    if (![body isKindOfClass:[NSDictionary class]]) {
        NSLog(@"YTPageParser: input is not NSDictionary");
        return nil;
    }
    
    NSDictionary *bodyDict = body;
    id entryParser = [self valueForKey:l(@"entryParser")];
    
    NSLog(@"class -> %@", [entryParser class]);
    
    
    if ([entryParser isKindOfClass:[_logos_static_class_lookup$YTSubscriptionParser() class]] ||
        [entryParser isKindOfClass:[_logos_static_class_lookup$YTCommentParser() class]] ||
        [entryParser isKindOfClass:[_logos_static_class_lookup$YTPlaylistParser() class]]) {
        return [self parseSpecializedFeed:bodyDict withEntryParser:entryParser error:error];
    }


    
    TRFeedTranslator *translator = [[[TRFeedTranslator alloc] init] autorelease];
    if ([entryParser isKindOfClass:[_logos_static_class_lookup$YTEventParser() class]]) {
        return [translator translateJSONAsEvent:bodyDict error:error];
    } else if ([entryParser isKindOfClass:[_logos_static_class_lookup$YTVideoParser() class]]) {
        return [translator translateVideoJSON:bodyDict error:error];
    } else if ([entryParser isKindOfClass:[_logos_static_class_lookup$YTChannelParser() class]]) {
        return [translator translateChannelJSON:bodyDict error:error];
    }
    return [translator translateVideoJSON:bodyDict error:error];
}

#pragma mark - Specialized Feed Parsing (subscriptions, comments, playlists)




static id _logos_method$_ungrouped$YTPageParser$parseSpecializedFeed$withEntryParser$error$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * bodyDict, id entryParser, NSError ** error) {
    
    NSArray *items = [self extractSpecializedItems:bodyDict forParser:entryParser];
    
    if (!items || [items count] == 0) {
        return [[_logos_static_class_lookup$YTPage() alloc] initWithEntries:@[] 
                                      totalResults:0 
                                    entriesPerPage:0 
                                        startIndex:0 
                                           nextURL:nil 
                                       previousURL:nil];
    }
    
    NSMutableArray *output = [NSMutableArray array];
    TRContinuation *continuation = nil;
    
    for (id item in items) {
        if (![item isKindOfClass:[NSDictionary class]]) continue;
        if ([item objectForKey:@"continuationItemRenderer"]) {
            continuation = [TRContinuation initWithToken:item[@"continuationItemRenderer"][@"continuationEndpoint"][@"continuationCommand"][@"token"]];
            continue;
        }
        
        
        NSError *parseError = nil;
        id entry = [entryParser parseElement:@{@"i": item, @"all": bodyDict} error:&parseError];
        
        if (parseError) {
            NSLog(@"YTPageParser: entry parser error: %@", parseError);
            break;
        }
        
        if (entry) {
            [output addObject:entry];
        }
    }
    
    YTPage *page = [[_logos_static_class_lookup$YTPage() alloc] initWithEntries:output 
                                          totalResults:[output count] 
                                        entriesPerPage:[output count] 
                                            startIndex:1 
                                               nextURL:continuation 
                                           previousURL:nil];

    return [page autorelease];
}


static NSArray * _logos_method$_ungrouped$YTPageParser$extractSpecializedItems$forParser$(_LOGOS_SELF_TYPE_NORMAL YTPageParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * bodyDict, id parser) {
    
    if ([parser isKindOfClass:[_logos_static_class_lookup$YTSubscriptionParser() class]]) {
        
        
        NSArray *guideSections = [TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"contents.twoColumnBrowseResultsRenderer.tabs[0].tabRenderer.content.sectionListRenderer.contents"];
        if ([guideSections count] == 0) {
            return nil;
        } else if ([guideSections count] == 1) {
            return [TRJSONUtils arrayFromJSON:guideSections[0] 
                    keyPath:@"itemSectionRenderer.contents[0].shelfRenderer.content.expandedShelfContentsRenderer.items"];
        }
        NSDictionary *continuation = nil;
        for (NSDictionary *section in guideSections) {
            if (section[@"continuationItemRenderer"]) {
                continuation = section[@"continuationItemRenderer"];
                break;
            }
        }
        for (NSDictionary *section in guideSections) {
            NSString *title = [TRJSONUtils stringFromJSON:section keyPath:@"itemSectionRenderer.contents[0].shelfRenderer.title.runs[0].text"];
            if (!title || [title isEqualToString:@"Subscribed"]) {
                if (continuation) {
                    return [[TRJSONUtils arrayFromJSON:section 
                        keyPath:@"itemSectionRenderer.contents[0].shelfRenderer.content.expandedShelfContentsRenderer.items"] arrayByAddingObjectsFromArray:@[continuation]];
                } else {
                    return [TRJSONUtils arrayFromJSON:section 
                        keyPath:@"itemSectionRenderer.contents[0].shelfRenderer.content.expandedShelfContentsRenderer.items"];
                }
            }
        }
        return nil;
    }
    
    
    if ([parser isKindOfClass:[_logos_static_class_lookup$YTCommentParser() class]]) {
        id feed = [TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"onResponseReceivedEndpoints[1].reloadContinuationItemsCommand.continuationItems"];
        if (feed) return feed;
        return [TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"onResponseReceivedEndpoints[0].appendContinuationItemsAction.continuationItems"];
    }
    
    
    if ([parser isKindOfClass:[_logos_static_class_lookup$YTPlaylistParser() class]]) {

        NSMutableArray *searchPlaylist = [[TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"contents.sectionListRenderer.contents[0].itemSectionRenderer.contents"] mutableCopy];
        if (!searchPlaylist) {
            searchPlaylist = [[TRJSONUtils arrayFromJSON:bodyDict 
                keyPath:@"onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems[0].itemSectionRenderer.contents"] mutableCopy];
        }
        if (searchPlaylist) {
            NSDictionary *continueStuff = [TRJSONUtils dictFromJSON:bodyDict 
                keyPath:@"contents.sectionListRenderer.contents[1]"];
            if (!continueStuff) {
                continueStuff = [TRJSONUtils dictFromJSON:bodyDict 
                keyPath:@"onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems[1]"];
            }
            
            if (continueStuff && continueStuff[@"continuationItemRenderer"]) {
                [searchPlaylist addObject:continueStuff];
            }
            return [searchPlaylist copy];
        } 



        NSArray *items = [TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"onResponseReceivedActions[0].appendContinuationItemsAction.continuationItems"];
        if (items) return items;

        NSArray *tabs = [TRJSONUtils arrayFromJSON:bodyDict 
            keyPath:@"contents.singleColumnBrowseResultsRenderer.tabs"];
        
        for (NSDictionary *tab in tabs) {
            NSString *tabTitle = [TRJSONUtils stringFromJSON:tab keyPath:@"tabRenderer.title"];
            if ([tabTitle isEqualToString:@"Playlists"]) {
                return [TRJSONUtils arrayFromJSON:tab 
                    keyPath:@"tabRenderer.content.sectionListRenderer.contents[0].itemSectionRenderer.contents"];
            }
        }
    }
    
    return nil;
}

#pragma mark - Legacy Helper for LockupViewModel


static id _logos_meta_method$_ungrouped$YTPageParser$parseLockupViewModelVideo$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary* unparsedVideo) {
    
    
    TRVideoTranslator *translator = [[[TRVideoTranslator alloc] init] autorelease];
    NSError *error = nil;
    return [translator translateJSON:@{@"lockupViewModel": unparsedVideo} error:&error];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTPageParser = objc_getClass("YTPageParser"); Class _logos_metaclass$_ungrouped$YTPageParser = object_getClass(_logos_class$_ungrouped$YTPageParser); { MSHookMessageEx(_logos_class$_ungrouped$YTPageParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTPageParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTPageParser$parseElement$error$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '@'; i += 1; memcpy(_typeEncoding + i, @encode(NSError **), strlen(@encode(NSError **))); i += strlen(@encode(NSError **)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTPageParser, @selector(parseSpecializedFeed:withEntryParser:error:), (IMP)&_logos_method$_ungrouped$YTPageParser$parseSpecializedFeed$withEntryParser$error$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSArray *), strlen(@encode(NSArray *))); i += strlen(@encode(NSArray *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTPageParser, @selector(extractSpecializedItems:forParser:), (IMP)&_logos_method$_ungrouped$YTPageParser$extractSpecializedItems$forParser$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary*), strlen(@encode(NSDictionary*))); i += strlen(@encode(NSDictionary*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$YTPageParser, @selector(parseLockupViewModelVideo:), (IMP)&_logos_meta_method$_ungrouped$YTPageParser$parseLockupViewModelVideo$, _typeEncoding); }} }
#line 208 "googleapp/feeds.x"
