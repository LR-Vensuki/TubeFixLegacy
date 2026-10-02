#line 1 "googleapp/subscriptions.x"





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

@class YTGDataService; @class YTSubscriptionParser; @class YTNotificationCenter; @class YTGDataRequest; @class YTGDataRequestFactory; 
static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionsWithAuth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionsWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionWithChannelID$auth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionWithChannelID$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToSubscribeWithChannelID$authentication$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToSubscribeWithChannelID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_meta_orig$_ungrouped$YTGDataRequest$requestToUnsubscribeWithSubscription$authentication$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTSubscription*, id); static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToUnsubscribeWithSubscription$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, YTSubscription*, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionsWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionsWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionWithChannelID$auth$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionWithChannelID$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToSubscribeWithChannelID$authentication$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToSubscribeWithChannelID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, NSString*, id); static id (*_logos_orig$_ungrouped$YTGDataRequestFactory$requestToUnsubscribeWithSubscription$authentication$)(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, YTSubscription*, id); static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToUnsubscribeWithSubscription$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST, SEL, YTSubscription*, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionRequestWithChannelID$authentication$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionRequestWithChannelID$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, NSString*, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionsRequest$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static void (*_logos_orig$_ungrouped$YTGDataService$makeUnsubscribeRequestWithSubscription$authentication$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTSubscription*, id, void (^)(void), void (^)(NSError *error)); static void _logos_method$_ungrouped$YTGDataService$makeUnsubscribeRequestWithSubscription$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTSubscription*, id, void (^)(void), void (^)(NSError *error)); static id (*_logos_orig$_ungrouped$YTSubscriptionParser$parseElement$error$)(_LOGOS_SELF_TYPE_NORMAL YTSubscriptionParser* _LOGOS_SELF_CONST, SEL, id, NSError *); static id _logos_method$_ungrouped$YTSubscriptionParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTSubscriptionParser* _LOGOS_SELF_CONST, SEL, id, NSError *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTNotificationCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTNotificationCenter"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 13 "googleapp/subscriptions.x"


static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionsWithAuth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder browseBodyWithId:@"FEchannels" 
                                                                  params:nil 
                                                                  client:[YoutubeClientType webClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionWithChannelID$auth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false&subscription=true" 
                       authentication:authentication 
                                 body:[TRRequestBuilder browseBodyWithId:channelId 
                                                                  params:@"EgZzaG9ydHPyBgUKA5oBAA%3D%3D" 
                                                                  client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToSubscribeWithChannelID$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/subscription/subscribe?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder subscribeBodyWithChannelId:channelId 
                                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_meta_method$_ungrouped$YTGDataRequest$requestToUnsubscribeWithSubscription$authentication$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTSubscription* subscription, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/subscription/unsubscribe?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder subscribeBodyWithChannelId:[subscription channelID] 
                                                                            client:[YoutubeClientType webMobileClient]]];
}




static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionsWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder browseBodyWithId:@"FEchannels" 
                                                                  params:nil 
                                                                  client:[YoutubeClientType webClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionWithChannelID$auth$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/browse?prettyprint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder browseBodyWithId:channelId 
                                                                  params:@"EgZzaG9ydHPyBgUKA5oBAA%3D%3D" 
                                                                  client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToSubscribeWithChannelID$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/subscription/subscribe?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder subscribeBodyWithChannelId:channelId 
                                                                            client:[YoutubeClientType webMobileClient]]];
}

static id _logos_method$_ungrouped$YTGDataRequestFactory$requestToUnsubscribeWithSubscription$authentication$(_LOGOS_SELF_TYPE_NORMAL YTGDataRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTSubscription* subscription, id authentication) {
    return [self requestWithURLString:@"https://www.youtube.com/youtubei/v1/subscription/unsubscribe?prettyPrint=false" 
                       authentication:authentication 
                                 body:[TRRequestBuilder subscribeBodyWithChannelId:[subscription channelID] 
                                                                            client:[YoutubeClientType webMobileClient]]];
}


#pragma mark - Request Dispatch



static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionRequestWithChannelID$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* channelId, id authentication, id responseBlock, id errorBlock) {
    
    id cache = [[self valueForKey:l(@"subscriptionCache")] objectForKey:channelId];
    
    if (cache) {
        if (cache == [NSNull null]) {
            cache = nil;
        }
        [self performResponseBlock:responseBlock response:cache];
    } else {
        id request = nil;
        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            request = [_logos_static_class_lookup$YTGDataRequest() requestForMySubscriptionWithChannelID:channelId auth:authentication];
        } else {
            request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestForMySubscriptionWithChannelID:channelId auth:authentication];
        }
        [self makePOSTRequest:request 
                   withParser:[self valueForKey:l(@"subscriptionParser")] 
                responseBlock:responseBlock 
                   errorBlock:errorBlock];
    }
}

static void _logos_method$_ungrouped$YTGDataService$makeMySubscriptionsRequest$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id responseBlock, id errorBlock) {
    [self makePOSTRequest:request 
               withParser:[self valueForKey:l(@"subscriptionPageParser")] 
            responseBlock:responseBlock
               errorBlock:errorBlock];               
}


static void _logos_method$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id authentication, id responseBlock, id errorBlock) {
    NSLog(@"makeSubscribeRequestWithChannelID:request -> %@", request);
    void (^originalResponseBlock)(id) = [responseBlock copy];
    void (^newResponseBlock)(id) = ^(id response) {
        YTChannel *channel = [[self channelCache] objectForKey:request];

        [response setValue:[channel displayName] forKey:l(@"displayName")];
        [response setValue:[channel thumbnailURL] forKey:l(@"thumbnailURL")];


        
        
        
        
        
        
        

        if (originalResponseBlock) {
            originalResponseBlock(response);
        }
    };
    _logos_orig$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$(self, _cmd, request, authentication, newResponseBlock, errorBlock);
}


static void _logos_method$_ungrouped$YTGDataService$makeUnsubscribeRequestWithSubscription$authentication$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTSubscription* subscription, id authentication, void (^responseBlock)(void), void (^errorBlock)(NSError *error)) {
  id request = nil;
  
  if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
    request = [_logos_static_class_lookup$YTGDataRequest() requestToUnsubscribeWithSubscription:subscription authentication:authentication];
  } else {
    request = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestToUnsubscribeWithSubscription:subscription authentication:authentication];
  }

    void (^successBlock)(id) = ^(id response) {
        [self clearSubscriptionDependentCaches];

        id channelID = [subscription channelID];
        [[self valueForKey:l(@"subscriptionCache")] setObject:[NSNull null] forKey:channelID];

        

        if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
            [_logos_static_class_lookup$YTNotificationCenter() notifySubscriptionChange:subscription
                                             subscribed:NO];
        } else {
            [self notifySubscriptionDidChange:subscription
                                             subscribed:NO];
        }
        

        if (responseBlock) {
            responseBlock();
        }
    };

    void (^failureBlock)(NSError *error) = ^(NSError *error) {
        if ([error code] == 404) {
            if (responseBlock) {
                responseBlock();
            }
        } else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    };
  [self makePOSTRequest:request withParser:nil responseBlock:successBlock errorBlock:failureBlock];







}



#pragma mark - Subscription Parsing


    
static id _logos_method$_ungrouped$YTSubscriptionParser$parseElement$error$(_LOGOS_SELF_TYPE_NORMAL YTSubscriptionParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id body, NSError * error) {
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        TRSubscriptionTranslator *translator = [[[TRSubscriptionTranslator alloc] init] autorelease];
        NSError *translatorError = nil;
        id subscription = [translator translateJSON:body error:&translatorError];
        
        if (translatorError) {
            NSLog(@"TRSubscriptionTranslator error: %@", translatorError);
        }
        
        return subscription;
    }
    
    NSLog(@"YTSubscriptionParser: input is not NSDictionary");
    return nil;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGDataRequest = objc_getClass("YTGDataRequest"); Class _logos_metaclass$_ungrouped$YTGDataRequest = object_getClass(_logos_class$_ungrouped$YTGDataRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMySubscriptionsWithAuth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionsWithAuth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionsWithAuth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestForMySubscriptionWithChannelID:auth:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestForMySubscriptionWithChannelID$auth$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestForMySubscriptionWithChannelID$auth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToSubscribeWithChannelID:authentication:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToSubscribeWithChannelID$authentication$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToSubscribeWithChannelID$authentication$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$YTGDataRequest, @selector(requestToUnsubscribeWithSubscription:authentication:), (IMP)&_logos_meta_method$_ungrouped$YTGDataRequest$requestToUnsubscribeWithSubscription$authentication$, (IMP*)&_logos_meta_orig$_ungrouped$YTGDataRequest$requestToUnsubscribeWithSubscription$authentication$);}Class _logos_class$_ungrouped$YTGDataRequestFactory = objc_getClass("YTGDataRequestFactory"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMySubscriptionsWithAuth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionsWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionsWithAuth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestForMySubscriptionWithChannelID:auth:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionWithChannelID$auth$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestForMySubscriptionWithChannelID$auth$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToSubscribeWithChannelID:authentication:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToSubscribeWithChannelID$authentication$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToSubscribeWithChannelID$authentication$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataRequestFactory, @selector(requestToUnsubscribeWithSubscription:authentication:), (IMP)&_logos_method$_ungrouped$YTGDataRequestFactory$requestToUnsubscribeWithSubscription$authentication$, (IMP*)&_logos_orig$_ungrouped$YTGDataRequestFactory$requestToUnsubscribeWithSubscription$authentication$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMySubscriptionRequestWithChannelID:authentication:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMySubscriptionRequestWithChannelID$authentication$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionRequestWithChannelID$authentication$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeMySubscriptionsRequest:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeMySubscriptionsRequest$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeMySubscriptionsRequest$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeSubscribeRequestWithChannelID:authentication:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeSubscribeRequestWithChannelID$authentication$responseBlock$errorBlock$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeUnsubscribeRequestWithSubscription:authentication:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeUnsubscribeRequestWithSubscription$authentication$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeUnsubscribeRequestWithSubscription$authentication$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTSubscriptionParser = objc_getClass("YTSubscriptionParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTSubscriptionParser, @selector(parseElement:error:), (IMP)&_logos_method$_ungrouped$YTSubscriptionParser$parseElement$error$, (IMP*)&_logos_orig$_ungrouped$YTSubscriptionParser$parseElement$error$);}} }
#line 217 "googleapp/subscriptions.x"
