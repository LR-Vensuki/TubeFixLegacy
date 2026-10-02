#line 1 "googleapp/channels.x"





#include <Foundation/Foundation.h>
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

@class YTGDataService; @class YTEventsFeedController; @class YTGDataRequestFactory; @class YTGDataRequest; @class YTChannelParser; @class YTVideosFeedController; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForChannelWithID$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelWithID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForChannelWithID$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelWithID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*); static void (*_logos_orig$_ungrouped$YTGDataService$makeChannelRequestWithID$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeChannelRequestWithID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id); static id (*_logos_orig$_ungrouped$YTChannelParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTChannelParser* _LOGOS_SELF_CONST, SEL, id, NSError*); static id _logos_method$_ungrouped$YTChannelParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTChannelParser* _LOGOS_SELF_CONST, SEL, id, NSError*); static void (*_logos_orig$_ungrouped$YTEventsFeedController$loadAvatarForEvent$)(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*); static void _logos_method$_ungrouped$YTEventsFeedController$loadAvatarForEvent$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*); static void (*_logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$)(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*); static void _logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*); static void (*_logos_orig$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$)(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, NSString*, YTEvent*); static void _logos_method$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, NSString*, YTEvent*); static void (*_logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$)(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*, YTEventCell_iPhone*); static void _logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST, SEL, YTEvent*, YTEventCell_iPhone*); static void (*_logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$)(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST, SEL, YTVideo*); static void _logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST, SEL, YTVideo*); static void (*_logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$)(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST, SEL, YTVideo*, YTEventCell_iPhone*); static void _logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST, SEL, YTVideo*, YTEventCell_iPhone*); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 13 "googleapp/channels.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelWithID$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false" 
                       authentication:nil 
                                 body:[TRRequestBuilder browseBodyWithId:channelId 
                                                                  params:@"EgZzaG9ydHPyBgUKA5oBAA%3D%3D" 
                                                                  client:[YoutubeClientType webMobileClient]]];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelWithID$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false" 
                       authentication:nil 
                                 body:[TRRequestBuilder browseBodyWithId:channelId 
                                                                  params:@"EgZzaG9ydHPyBgUKA5oBAA%3D%3D" 
                                                                  client:[YoutubeClientType webMobileClient]]];
}



#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeChannelRequestWithID$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id responseBlock, id errorBlock) {
    id cache = [[self channelCache] objectForKey:channelId];
    if (cache) {
        if (cache == [NSNull null]) {
            cache = nil;
        }
        [self performResponseBlock:responseBlock response:cache];
    } else {
        NSLog(@"Channel cache miss!");
        id url = nil;
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            url = [_logos_static_class_lookup$YTGDataRequest() requestForChannelWithID:channelId];
            
        } else {
            url = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestForChannelWithID:channelId];
        }
        [self makePOSTRequest:url 
                    withParser:[self valueForKey:l(@"channelParser")] 
                    responseBlock:responseBlock 
                    errorBlock:errorBlock];
    }
}



#pragma mark - Channel Parsing



static id _logos_method$_ungrouped$YTChannelParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTChannelParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id body, NSError* error) {
    if ([body isKindOfClass:[NSDictionary class]]) {
        TRChannelTranslator *translator = [[[TRChannelTranslator alloc] init] autorelease];
        NSError *translatorError = nil;
        id channel = [translator translateJSON:body error:&translatorError];
        
        if (translatorError) {
            NSLog(@"TRChannelTranslator error: %@", translatorError);
            error = translatorError;
        }
        
        return channel;
    } else {
        NSLog(@"YTChannelParser: input is not NSDictionary");
        return nil;
    }
}



 


static void _logos_method$_ungrouped$YTEventsFeedController$loadAvatarForEvent$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTEvent* entry) {
    if ([entry action] != 9) {
        NSURL *profilePicture = nil;
        if ([[[entry video] uploaderChannelID] isEqualToString:[entry authorUserID]]) {
            profilePicture = objc_getAssociatedObject([entry video], "uploaderChannelProfilePicture");
        }

        if (profilePicture) {
            YTImageService *imageService = [(YTServices*)[self valueForKey:l(@"services")] imageService];
            [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
                [self setAvatar:image forEntry:entry];
                [self updateCellForEntry:entry animated:YES];
            } errorBlock:^(NSError *error){
                
            }];
        } else {
            return _logos_orig$_ungrouped$YTEventsFeedController$loadAvatarForEvent$(self, _cmd, entry);
        }
    }
}

static void _logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTEvent* entry) {
    if (![entry isYouTubeAuthored]) {
        NSURL *profilePicture = nil;
        if ([[[entry video] uploaderChannelID] isEqualToString:[entry authorUserID]]) {
            profilePicture = objc_getAssociatedObject([entry video], "uploaderChannelProfilePicture");
        }

        if (profilePicture) {
            YTImageService *imageService = [self valueForKey:l(@"imageService")];
            [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
                [self setChannelThumbnail:image forEntry:entry];
                [self updateCellForEntry:entry animated:YES];
            } errorBlock:^(NSError *error){
                
            }];
        } else {
            return _logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$(self, _cmd, entry);
        }
    }
}

static void _logos_method$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, YTEvent* entry) {
    
    NSURL *profilePicture = nil;
    if ([[[entry video] uploaderChannelID] isEqualToString:[entry authorUserID]]) {
        profilePicture = objc_getAssociatedObject([entry video], "uploaderChannelProfilePicture");
    }

    BOOL hasSel = NO;
    if ([version() isEqualToString:@"1.2.1"]) {
        hasSel = [(id<YTFeedViewProtocol>)[self valueForKey:l(@"feedView")] cellsRespondToSelector:@selector(setUploaderThumbnail:animated:)];
    } else {
        hasSel = [(id<YTFeedViewProtocol>)[self valueForKey:l(@"feedView")] cellsRespondToSelector:@selector(setUploaderThumbnail:animated:) forEntry:entry];
    }

    if (profilePicture) {
        if (channelId != nil
            && hasSel != NO) {

                YTImageService *imageService = [self valueForKey:l(@"imageService")];
                [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
                    [self setUploaderThumbnail:image forEntry:entry];
                    [self updateCellForEntry:entry animated:YES];
                } errorBlock:^(NSError *error){
                    
                }];
        }
        
    } else {
        return _logos_orig$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$(self, _cmd, channelId, entry);
    }
}


static void _logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$(_LOGOS_SELF_TYPE_NORMAL YTEventsFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTEvent* entry, YTEventCell_iPhone* inCell) { 
    if ([entry isYouTubeAuthored]) {
        [inCell setChannelThumbnail:[self valueForKey:l(@"YouTubeSystemChannelImage")] animated:0];
    } else {
        NSURL *profilePicture = nil;
        if ([[[entry video] uploaderChannelID] isEqualToString:[entry authorUserID]]) {
            profilePicture = objc_getAssociatedObject([entry video], "uploaderChannelProfilePicture");
        }

        if (profilePicture) {
            YTImageService *imageService = [self valueForKey:l(@"imageService")];
            [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
                [inCell setChannelThumbnail:image animated:0];
            } errorBlock:^(NSError *error){
                
            }];
        } else {
            return _logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$(self, _cmd, entry, inCell);
        }
    }
}






    
static void _logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* entry) {
    NSURL *profilePicture = objc_getAssociatedObject(entry, "uploaderChannelProfilePicture");
    
    BOOL hasSel = NO;
    if ([version() isEqualToString:@"1.2.1"]) {
        hasSel = [(id<YTFeedViewProtocol>)[self valueForKey:l(@"feedView")] cellsRespondToSelector:@selector(setUploaderThumbnail:animated:)];
    } else {
        hasSel = [(id<YTFeedViewProtocol>)[self valueForKey:l(@"feedView")] cellsRespondToSelector:@selector(setUploaderThumbnail:animated:) forEntry:entry];
    }

    if (profilePicture && hasSel) {
        YTImageService *imageService = [self valueForKey:l(@"imageService")];
        [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
            [self setUploaderThumbnail:image forEntry:entry];
            [self updateCellForEntry:entry animated:YES];
        } errorBlock:^(NSError *error){
            
        }];
    } else {
        NSLog(@"sad");
        return _logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$(self, _cmd, entry);
    }
}

static void _logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$(_LOGOS_SELF_TYPE_NORMAL YTVideosFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* entry, YTEventCell_iPhone* inCell) { 
    NSURL *profilePicture = objc_getAssociatedObject(entry, "uploaderChannelProfilePicture");

    if (profilePicture && [inCell respondsToSelector:@selector(setChannelThumbnail:animated:)]) {
        YTImageService *imageService = [self valueForKey:l(@"imageService")];
        [imageService makeImageRequestWithURL:profilePicture responseBlock:^(id image, BOOL unk2) {
            [inCell setChannelThumbnail:image animated:0];
        } errorBlock:^(NSError *error){
            
        }];
    } else {
        return _logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$(self, _cmd, entry, inCell);
    }
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForChannelWithID:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForChannelWithID$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForChannelWithID$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForChannelWithID:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForChannelWithID$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForChannelWithID$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeChannelRequestWithID:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeChannelRequestWithID$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeChannelRequestWithID$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTChannelParser = objc_getClass("YTChannelParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTChannelParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTChannelParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTChannelParser$parseElement$error$);}Class _logos_class$_ungrouped$YTEventsFeedController = objc_getClass("YTEventsFeedController"); { MSHookMessageEx(_logos_class$_ungrouped$YTEventsFeedController, @selector(loadAvatarForEvent:), (IMP)&_logos_method$_ungrouped$YTEventsFeedController$loadAvatarForEvent$, (IMP*)&_logos_orig$_ungrouped$YTEventsFeedController$loadAvatarForEvent$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTEventsFeedController, @selector(loadChannelThumbnailForEvent:), (IMP)&_logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$, (IMP*)&_logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTEventsFeedController, @selector(loadUploaderThumbnailWithID:forEntry:), (IMP)&_logos_method$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$, (IMP*)&_logos_orig$_ungrouped$YTEventsFeedController$loadUploaderThumbnailWithID$forEntry$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTEventsFeedController, @selector(loadChannelThumbnailForEvent:inCell:), (IMP)&_logos_method$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$, (IMP*)&_logos_orig$_ungrouped$YTEventsFeedController$loadChannelThumbnailForEvent$inCell$);}Class _logos_class$_ungrouped$YTVideosFeedController = objc_getClass("YTVideosFeedController"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideosFeedController, @selector(loadChannelThumbnailWithVideo:), (IMP)&_logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$, (IMP*)&_logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailWithVideo$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTVideosFeedController, @selector(loadChannelThumbnailForVideo:inCell:), (IMP)&_logos_method$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$, (IMP*)&_logos_orig$_ungrouped$YTVideosFeedController$loadChannelThumbnailForVideo$inCell$);}} }
#line 236 "googleapp/channels.x"
