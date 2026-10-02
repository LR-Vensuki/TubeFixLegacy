#line 1 "googleapp/parsing.x"






#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "Translators/TRTranslators.h"
#include "general.h"

#pragma mark - Format Detection & Parsing


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

@class YTTBXMLElement; @class PendingRequestKey; @class TBXML; @class YTGDataService; @class YTBaseService; @class YTTBParser; 
static id (*_logos_orig$_ungrouped$YTTBParser$parse$error$)(_LOGOS_SELF_TYPE_NORMAL YTTBParser* _LOGOS_SELF_CONST, SEL, NSData*, NSError **); static id _logos_method$_ungrouped$YTTBParser$parse$error$(_LOGOS_SELF_TYPE_NORMAL YTTBParser* _LOGOS_SELF_CONST, SEL, NSData*, NSError **); static void (*_logos_orig$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest *, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTGDataRequest *, id, id, id); static void (*_logos_orig$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$)(_LOGOS_SELF_TYPE_NORMAL YTBaseService* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$(_LOGOS_SELF_TYPE_NORMAL YTBaseService* _LOGOS_SELF_CONST, SEL, id, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$TBXML(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("TBXML"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$PendingRequestKey(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("PendingRequestKey"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTTBXMLElement(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTTBXMLElement"); } return _klass; }
#line 14 "googleapp/parsing.x"


static id _logos_method$_ungrouped$YTTBParser$parse$error$(_LOGOS_SELF_TYPE_NORMAL YTTBParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData* rawData, NSError ** error) {
    if (!rawData || [rawData length] == 0) {
        NSLog(@"TubeFixLegacy: Empty data received");
        return nil;
    }

    
    
    const unsigned char* bytes = [rawData bytes];
    NSUInteger length = [rawData length];
    NSData *cleanData = rawData;

    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    if (preferences[@"DebugNetworkRequests"]) {
        NSString *path = @"/var/mobile/Library/Preferences/tubefixlegacy_network_log.txt";
        NSFileManager *fileManager = [NSFileManager defaultManager];

        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        NSMutableData *dataToWrite = [NSMutableData data];
        [dataToWrite appendData:[@"========Tub3R3p1@c3r_Un1qu3-S3p3r@t0r_!&479(21!#9hfa@a1===============" dataUsingEncoding:NSUTF8StringEncoding]];
        [dataToWrite appendData:rawData];

        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:dataToWrite];
        [fileHandle closeFile];
    }
    
    
    
    if (length >= 5 && 
        bytes[0] == ')' && 
        bytes[1] == ']' && 
        bytes[2] == '}' && 
        bytes[3] == '\'' && 
        bytes[4] == '\n') {
        bytes += 5;
        length -= 5;
        cleanData = [NSData dataWithBytes:bytes length:length];
    }
    
    
    if (length > 0 && bytes[0] == '<') {
        
        NSLog(@"TubeFixLegacy: XML detected, using TBXML");
        TBXML *xml = [_logos_static_class_lookup$TBXML() tbxmlWithXMLData:cleanData error:error];
        if ([xml rootXMLElement]) {
            YTTBXMLElement *rootElement = [[[_logos_static_class_lookup$YTTBXMLElement() alloc] 
                initWithElement:[xml rootXMLElement]] autorelease];
            return [self parseElement:rootElement error:error];
        }
        return nil;
    } 
    else if (length > 0 && bytes[0] == '{') {
        
        NSLog(@"TubeFixLegacy: JSON detected");
        id json = [NSJSONSerialization 
            JSONObjectWithData:cleanData 
            options:NSJSONReadingMutableContainers 
            error:error];
        
        if (!json) {
            NSLog(@"TubeFixLegacy: JSON parsing failed");
            return nil;
        }
        
        
        return [self parseElement:json error:error];
    } 
    else {
        NSLog(@"TubeFixLegacy: Unknown format, first byte: 0x%02X", bytes[0]);
        return nil;
    }
}



#pragma mark - POST Request Caching






static void _logos_method$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTGDataRequest * request, id parser, id responseBlock, id errorBlock) {
    
    
    void (^originalResponseBlock)(id) = [responseBlock copy];

    void (^wrappedResponseBlock)(id) = ^(id response) {
        
        NSLog(@"parser -> %@", parser);
        if (parser == [self valueForKey:l(@"subscriptionPageParser")]) {
            id cache = [self valueForKey:l(@"subscriptionCache")];
            [cache setValue:@100000 forKey:l(@"countLimit")];
            [self cacheSubscriptionsFromSubscriptionPage:response];
        }

        if (parser == [self valueForKey:l(@"channelParser")]) {
            id cache = [self channelCache];
            [cache setValue:@100000 forKey:l(@"countLimit")];
            [self cacheChannel:response];
        }

        

        if (parser == [self valueForKey:l(@"channelPageParser")]) {
            id cache = [self channelCache];
            for (id channel in [response entries]) {
                [cache setValue:@100000 forKey:l(@"countLimit")];
                [self cacheChannel:channel];
            }
            
        }

        if (originalResponseBlock) {
            originalResponseBlock(response);
        }
    };

    _logos_orig$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$(self, _cmd, request, parser, wrappedResponseBlock, errorBlock);
    
    [originalResponseBlock release];
}



@interface PendingRequestKey

-(id)keyWithRequest:(id)a3 authorizer:(id)a4;

@end





static void _logos_method$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$(_LOGOS_SELF_TYPE_NORMAL YTBaseService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id withAuthorizer, id completionBlock) {
    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
        return _logos_orig$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$(self, _cmd, request, withAuthorizer, completionBlock);
    } else {
        id copiedCompletionBlock = [completionBlock copy];

        NSBlockOperation *operation =
        [NSBlockOperation blockOperationWithBlock:^{

            id requestKey =
            [_logos_static_class_lookup$PendingRequestKey() keyWithRequest:request authorizer:withAuthorizer];

            id completionBlock2 = [copiedCompletionBlock autorelease];

            NSMutableArray *v6 =
            [NSMutableArray arrayWithObject:completionBlock2];

            [[self valueForKey:l(@"pendingRequests")]
                setObject:v6 forKey:requestKey];

            GTMHTTPFetcher *fetcher =
            [[self valueForKey:l(@"httpFetcherService")]
                fetcherWithRequest:request];

            [fetcher setAuthorizer:withAuthorizer];

            [fetcher beginFetchWithCompletionHandler:
            ^(NSData *data, NSError *error) {

                for (void (^block)(NSData *, NSError *) in v6) {
                    block(data, error);
                }

                [(NSMutableDictionary*)
                [self valueForKey:l(@"pendingRequests")]
                removeObjectForKey:requestKey];
            }];
        }];

        [[NSOperationQueue mainQueue] addOperation:operation];
    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTTBParser = objc_getClass("YTTBParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTTBParser, @selector(parse:error:), (IMP)&_logos_method$_ungrouped$YTTBParser$parse$error$, (IMP*)&_logos_orig$_ungrouped$YTTBParser$parse$error$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makePOSTRequest:withParser:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makePOSTRequest$withParser$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTBaseService = objc_getClass("YTBaseService"); { MSHookMessageEx(_logos_class$_ungrouped$YTBaseService, @selector(performHTTPRequest:withAuthorizer:completionBlock:), (IMP)&_logos_method$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$, (IMP*)&_logos_orig$_ungrouped$YTBaseService$performHTTPRequest$withAuthorizer$completionBlock$);}} }
#line 198 "googleapp/parsing.x"
