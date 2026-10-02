#line 1 "googleapp/network.x"














#import <Foundation/Foundation.h>
#import "general.h"

@protocol TFLDiagnosticsRequest
- (id)URL;
@end

static const double kTFLMinimumRequestTimeout = 30.0;





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

@class YTGDataService; @class NSURLRequest; 
static id (*_logos_meta_orig$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, double); static id _logos_meta_method$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, double); static id (*_logos_meta_orig$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *); static id _logos_meta_method$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *); static void (*_logos_orig$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id, id); static void _logos_method$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id, id); 

#line 27 "googleapp/network.x"



static id _logos_meta_method$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, double timeout) {
    return _logos_meta_orig$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$(self, _cmd, url, timeout < kTFLMinimumRequestTimeout ? kTFLMinimumRequestTimeout : timeout);
}


static id _logos_meta_method$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url) {
    id request = _logos_meta_orig$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$(self, _cmd, url);
    if ([request isKindOfClass:[NSMutableURLRequest class]] && [request timeoutInterval] < kTFLMinimumRequestTimeout) {
        [(NSMutableURLRequest *)request setTimeoutInterval:kTFLMinimumRequestTimeout];
    }
    return request;
}






static void _logos_method$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id request, id method, id parser, id responseBlock, id errorBlock) {
    if (TRVerboseLogging()) {
        id url = [request respondsToSelector:@selector(URL)] ? [(id<TFLDiagnosticsRequest>)request URL] : request;
        TFLLog(@"%@ %@", method, url);
        void (^originalErrorBlock)(id) = [[errorBlock copy] autorelease];
        errorBlock = [[^(id error) {
            TFLLog(@"request failed: %@ %@ -> %@", method, url, error);
            if (originalErrorBlock) {
                originalErrorBlock(error);
            }
        } copy] autorelease];
    }
    _logos_orig$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$(self, _cmd, request, method, parser, responseBlock, errorBlock);
}



static __attribute__((constructor)) void _logosLocalCtor_ca6a4934(int __unused argc, char __unused **argv, char __unused **envp) {
    if (TRShouldLoadGoogleHooks()) {
        {Class _logos_class$_ungrouped$NSURLRequest = objc_getClass("NSURLRequest"); Class _logos_metaclass$_ungrouped$NSURLRequest = object_getClass(_logos_class$_ungrouped$NSURLRequest); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSURLRequest, @selector(defaultRequestWithURL:timeout:), (IMP)&_logos_meta_method$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$, (IMP*)&_logos_meta_orig$_ungrouped$NSURLRequest$defaultRequestWithURL$timeout$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSURLRequest, @selector(defaultMutableRequestWithURL:), (IMP)&_logos_meta_method$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$, (IMP*)&_logos_meta_orig$_ungrouped$NSURLRequest$defaultMutableRequestWithURL$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(makeCustomRequest:method:parser:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$makeCustomRequest$method$parser$responseBlock$errorBlock$);}}
    }
}
