#line 1 "googleapp/myprofile.x"





#include <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
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

@class YTGDataService; @class YTUserProfileParser; @class YTGDataRequestFactory; @class YTGDataRequest; @class YTUserProfile; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyUserProfileWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUserProfileWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyUserProfileWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUserProfileWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyUserProfileRequestWithAuth$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, GTMOAuth2Authentication*, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyUserProfileRequestWithAuth$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, GTMOAuth2Authentication*, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMyManagedChannelsRequestWithAuth$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMyManagedChannelsRequestWithAuth$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static id (*_logos_orig$_ungrouped$YTUserProfileParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTUserProfileParser* _LOGOS_SELF_CONST, SEL, id, NSError *); static id _logos_method$_ungrouped$YTUserProfileParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTUserProfileParser* _LOGOS_SELF_CONST, SEL, id, NSError *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTUserProfile(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTUserProfile"); } return _klass; }
#line 14 "googleapp/myprofile.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUserProfileWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    
    return [self requestWithURLString:@"https://m.youtube.com/getAccountSwitcherEndpoint" 
                       authentication:authentication];
}





static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUserProfileWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    
    return [self requestWithURLString:@"https://m.youtube.com/getAccountSwitcherEndpoint" 
                       authentication:authentication];
}



#pragma mark - Request Dispatch

 

static void _logos_method$_ungrouped$YTGDataService$makeMyUserProfileRequestWithAuth$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GTMOAuth2Authentication* auth, id responseBlock, id errorBlock) {
    id request;
    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"])  {
        request = [_logos_static_class_lookup$YTGDataRequest() requestForMyUserProfileWithAuth:auth];
    } else {
        request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestForMyUserProfileWithAuth:auth];

    }

    void (^originalResponseBlock)(id) = [responseBlock copy];
    void (^newResponseBlock)(id) = ^(NSArray *accounts) {
        if (!originalResponseBlock) return;
        
        NSDictionary *accountInfo = nil;
        for (NSDictionary *account in accounts) {
            
            NSString *accountPageId = [TRJSONUtils stringFromJSON:account keyPath:@"accountItem.serviceEndpoint.selectActiveIdentityEndpoint.supportedTokens[0].pageIdToken.pageId"];
            if ([auth pageID] == nil && accountPageId == nil) {
                accountInfo = account[@"accountItem"];
                break;
            }
            if ([accountPageId isEqualToString:[auth pageID]]) {
                accountInfo = account[@"accountItem"];
                break;
            }
        }

        if (!accountInfo) {
            NSLog(@"YTUserProfileParser: Could not find account info");
            originalResponseBlock(nil);
            return;
        }
        
        NSString *displayName = [TRJSONUtils stringFromJSON:accountInfo keyPath:@"accountName.simpleText"];
        
        NSString *channelHandle = [TRJSONUtils stringFromJSON:accountInfo keyPath:@"channelHandle.simpleText"];
        if ([channelHandle hasPrefix:@"@"]) {
            channelHandle = [channelHandle substringFromIndex:1];
        }
        
        NSString *bylineText = [TRJSONUtils stringFromJSON:accountInfo keyPath:@"accountByline.simpleText"];
        int subscribersCount = (int)[TRJSONUtils numberFromText:bylineText];
        
        NSString *thumbUrl = [TRJSONUtils stringFromJSON:accountInfo keyPath:@"accountPhoto.thumbnails[0].url"];
        NSURL *thumbnail = thumbUrl ? [NSURL URLWithString:thumbUrl] : nil;
        
        YTUserProfile *profile = nil;
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            profile = [[[_logos_static_class_lookup$YTUserProfile() alloc] 
                initWithUsername:channelHandle
                displayName:displayName
                age:0
                thumbnailURL:thumbnail
                uploadsURL:[NSURL URLWithString:@"https://youtube.com"]
                playlistsURL:[NSURL URLWithString:@"https://youtube.com"]
                uploadedCount:0
                favoritesCount:0
                subscriptionsCount:0
                uploadViewsCount:0
                channelViewsCount:0
                subscribersCount:subscribersCount
            ] autorelease];
        } else if ([version() isEqualToString:@"1.1.0"])  {
            profile = [[[_logos_static_class_lookup$YTUserProfile() alloc] 
                initWithDisplayName:displayName
                channelID:channelHandle
                age:0
                thumbnailURL:thumbnail
                uploadsURL:[NSURL URLWithString:@"https://youtube.com"]
                playlistsURL:[NSURL URLWithString:@"https://youtube.com"]
                uploadedCount:0
                favoritesCount:0
                subscriptionsCount:0
                uploadViewsCount:0
                channelViewsCount:0
                subscribersCount:subscribersCount
            ] autorelease];
        } else if ([version() isEqualToString:@"1.2.1"] || [version() isEqualToString:@"1.3.0"] || [version() isEqualToString:@"1.4.0"]) {
            profile = [[[_logos_static_class_lookup$YTUserProfile() alloc] 
                initWithDisplayName:displayName
                hasChannel:true 
                channelID:channelHandle
                eligibleForChannel:true 
                googlePlusUserID:nil 
                age:0
                thumbnailURL:thumbnail
                uploadsURL:[NSURL URLWithString:@"https://youtube.com"]
                playlistsURL:[NSURL URLWithString:@"https://youtube.com"]
                uploadedCount:0
                favoritesCount:0
                subscriptionsCount:0
                uploadViewsCount:0
                channelViewsCount:0
                subscribersCount:subscribersCount
            ] autorelease];
        } else { 
            profile = [[[_logos_static_class_lookup$YTUserProfile() alloc] 
                initWithDisplayName:displayName
                hasChannel:true 
                channelID:channelHandle
                channelName:displayName 
                eligibleForChannel:true 
                googlePlusUserID:nil 
                age:0
                thumbnailURL:thumbnail
                uploadsURL:[NSURL URLWithString:@"https://youtube.com"]
                playlistsURL:[NSURL URLWithString:@"https://youtube.com"]
                uploadedCount:0
                favoritesCount:0
                subscriptionsCount:0
                uploadViewsCount:0
                channelViewsCount:0
                subscribersCount:subscribersCount
            ] autorelease];
        }
        originalResponseBlock(profile);
    };

    [self makeGETRequest:request 
              withParser:[self valueForKey:l(@"userProfileParser")] 
           responseBlock:newResponseBlock 
              errorBlock:errorBlock];
}


static void _logos_method$_ungrouped$YTGDataService$makeMyManagedChannelsRequestWithAuth$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id auth, id responseBlock, id errorBlock) {
    
    
    id sub = [[[NSClassFromString(@"YTSubscription") alloc] 
            initWithDisplayName:@"channel name"
            channelID:@"channel id"
            type:1
            publishedDate:[NSDate date]
            updatedDate:[NSDate date]
            countHint:0
            unreadCount:0 
            editURL:[NSURL URLWithString:@"https://youtube.com"]
            thumbnailURL:[NSURL URLWithString:@"https://youtube.com"]
        ] autorelease];


    id page = [[[NSClassFromString(@"YTPage") alloc] 
        initWithEntries:@[sub] 
        totalResults:1 
        entriesPerPage:1
        startIndex:1 
        nextURL:nil 
        previousURL:nil
    ] autorelease];
    [self performResponseBlock:responseBlock response:page];

}




#pragma mark - Profile Parsing


    
static id _logos_method$_ungrouped$YTUserProfileParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTUserProfileParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id body, NSError * error) {
    if (![body isKindOfClass:[NSDictionary class]]) {
        NSLog(@"YTUserProfileParser: input is not NSDictionary");
        return nil;
    }
    
    NSDictionary *data = body;
    NSArray *accounts = [TRJSONUtils arrayFromJSON:data 
        keyPath:@"data.actions[0].getMultiPageMenuAction.menu.multiPageMenuRenderer.sections[0].accountSectionListRenderer.contents[0].accountItemSectionRenderer.contents"];
    return accounts;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMyUserProfileWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMyUserProfileWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMyUserProfileWithAuth$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMyUserProfileWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMyUserProfileWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMyUserProfileWithAuth$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyUserProfileRequestWithAuth:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyUserProfileRequestWithAuth$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyUserProfileRequestWithAuth$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMyManagedChannelsRequestWithAuth:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMyManagedChannelsRequestWithAuth$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMyManagedChannelsRequestWithAuth$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTUserProfileParser = objc_getClass("YTUserProfileParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTUserProfileParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTUserProfileParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTUserProfileParser$parseElement$error$);}} }
#line 211 "googleapp/myprofile.x"
