#line 1 "googleapp/general.x"
#include "appheaders.h"
#include "general.h"
#import "../common/TRVersionSupport.h"
#import "sys/utsname.h"
#import <objc/runtime.h>

@interface NSURLConnection(YouTube)

+(NSString*)userAgent;
+(NSMutableURLRequest*)requestWithRequest:(NSURLRequest*)request;

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

@class NSURLConnection; @class YTItemListHeader; @class YTGDataService; @class YTCache; @class YTPage; @class GIPSpeechController; @class NSAssertionHandler; 
static NSMutableURLRequest* (*_logos_meta_orig$_ungrouped$NSURLConnection$requestWithRequest$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURLRequest*); static NSMutableURLRequest* _logos_meta_method$_ungrouped$NSURLConnection$requestWithRequest$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURLRequest*); static void (*_logos_meta_orig$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURLRequest*, id, id); static void _logos_meta_method$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURLRequest*, id, id); static YTGDataService* (*_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static YTGDataService* (*_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id, id); static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id, id); static YTGDataService* (*_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$)(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, id, id, id, id); static YTCache* _logos_method$_ungrouped$YTGDataService$channelCache(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTGDataService$cacheChannel$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST, SEL, YTChannel*); static NSString* (*_logos_orig$_ungrouped$GIPSpeechController$serverURL)(_LOGOS_SELF_TYPE_NORMAL GIPSpeechController* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$GIPSpeechController$serverURL(_LOGOS_SELF_TYPE_NORMAL GIPSpeechController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$)(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST, SEL, NSString *, NSString *, NSInteger, NSString *); static void _logos_method$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST, SEL, NSString *, NSString *, NSInteger, NSString *); static void (*_logos_orig$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$)(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST, SEL, SEL, id, NSString *, NSInteger, NSString *, ...); static void _logos_method$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST, SEL, SEL, id, NSString *, NSInteger, NSString *, ...); static void (*_logos_orig$_ungrouped$YTItemListHeader$setItemCount$)(_LOGOS_SELF_TYPE_NORMAL YTItemListHeader* _LOGOS_SELF_CONST, SEL, unsigned int); static void _logos_method$_ungrouped$YTItemListHeader$setItemCount$(_LOGOS_SELF_TYPE_NORMAL YTItemListHeader* _LOGOS_SELF_CONST, SEL, unsigned int); static int (*_logos_orig$_ungrouped$YTPage$totalResults)(_LOGOS_SELF_TYPE_NORMAL YTPage* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$YTPage$totalResults(_LOGOS_SELF_TYPE_NORMAL YTPage* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTCache(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTCache"); } return _klass; }
#line 14 "googleapp/general.x"
 



static NSMutableURLRequest* _logos_meta_method$_ungrouped$NSURLConnection$requestWithRequest$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURLRequest* request) {
    NSMutableURLRequest *copy = [request mutableCopyWithZone:0];
    if ([copy valueForHTTPHeaderField:@"OV-User-Agent"]) {
        [copy setValue:[[copy valueForHTTPHeaderField:@"OV-User-Agent"] copy] forHTTPHeaderField:@"User-Agent"];
        return copy;
    } else if ([copy valueForHTTPHeaderField:@"Ov-User-Agent"]) {
        [copy setValue:[[copy valueForHTTPHeaderField:@"Ov-User-Agent"] copy] forHTTPHeaderField:@"User-Agent"];
        return copy;
    } else {
        [copy setValue:[NSURLConnection userAgent] forHTTPHeaderField:@"User-Agent"];
        return copy;
    }
}


static void _logos_meta_method$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURLRequest* request, id queue, id completionHandler) {
    _logos_meta_orig$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$(self, _cmd, [[NSURLConnection requestWithRequest:request] autorelease], queue, completionHandler);
}





static void analytics() {
}

static void compat_check() {
    
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"] || [version() isEqualToString:@"1.1.0"] || [version() isEqualToString:@"1.2.1"])) {
            NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
            if ([systemVersion floatValue] >= 9.0) {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compatibility Alert"
                                                        message:@"iOS 9 and above on iPad have issues when on YouTube versions 1.2.1 and below. It is highly recommended to update to YouTube 1.3.0 or above for complete functionality. TubeFixLegacy works best on 1.3.0 or newer there."
                                                    delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    if (!TRIsSupportedGoogleVersion(version())) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compatibility Alert"
                                                message:@"YouTube versions above 2.2.x are not supported on this version of TubeFixLegacy. Install YouTube 1.0.0-1.4.0 or 2.0.0-2.2.0, or keep \"Legacy Version Fallback\" on in TubeFixLegacy's settings to use this version through a TubeRepair server."
                                            delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id a3, id a4, id a5, id a6) {
    id orig = _logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$(self, _cmd, a3, a4, a5, a6);
    compat_check();
    analytics();
    if (orig) {
        objc_setAssociatedObject(orig, @"channelCache_", [[_logos_static_class_lookup$YTCache() alloc] initWithExpirationInterval:1086070784 countLimit:500], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}


static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id a3, id a4, id a5, id a6, id a7) {
    id orig = _logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$(self, _cmd, a3, a4, a5, a6, a7);
    compat_check();
    analytics();
    if (orig) {
        objc_setAssociatedObject(orig, @"channelCache_", [[_logos_static_class_lookup$YTCache() alloc] initWithExpirationInterval:1086070784 countLimit:500], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}


static YTGDataService* _logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id a3, id a4, id a5, id a7) {
    id orig = _logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$(self, _cmd, a3, a4, a5, a7);
    compat_check();
    analytics();
    if (orig) {
        id channelCache = [[_logos_static_class_lookup$YTCache() alloc] initWithExpirationInterval:1086070784 countLimit:500];
        objc_setAssociatedObject(orig, @"channelCache_", channelCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}


static YTCache* _logos_method$_ungrouped$YTGDataService$channelCache(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return objc_getAssociatedObject(self, @"channelCache_");
}



static void _logos_method$_ungrouped$YTGDataService$cacheChannel$(_LOGOS_SELF_TYPE_NORMAL YTGDataService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTChannel* channel) {


    if (channel) {
        [[self channelCache] setObject:channel forKey:[channel channelID]];
    }

    
}




 


static NSString* _logos_method$_ungrouped$GIPSpeechController$serverURL(_LOGOS_SELF_TYPE_NORMAL GIPSpeechController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  return @"http://www.google.com/m/voice-search"; 
}
    




    



static void _logos_method$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * functionName, NSString * fileName, NSInteger line, NSString * format) {
    NSLog(@"Assert failed! Function %@ @ %@:%i, %@",functionName,fileName,(int)line,format);
    return _logos_orig$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$(self, _cmd, functionName, fileName, line, format);
}





static void _logos_method$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$(_LOGOS_SELF_TYPE_NORMAL NSAssertionHandler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, SEL selector, id object, NSString * fileName, NSInteger line, NSString * format, ...) {
    
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    NSLog(@"[GTM-Assert-Hook] Method: %@ | File: %@:%ld | Error: %@", 
          NSStringFromSelector(selector), 
          fileName.lastPathComponent, 
          (long)line, 
          description);

    _logos_orig$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$(self, _cmd, selector, object, fileName, line, format);
}





static void _logos_method$_ungrouped$YTItemListHeader$setItemCount$(_LOGOS_SELF_TYPE_NORMAL YTItemListHeader* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, unsigned int count) {
    
    if (count == 2147483647) return;
    return _logos_orig$_ungrouped$YTItemListHeader$setItemCount$(self, _cmd, count);
}

#import <execinfo.h>



 

static int _logos_method$_ungrouped$YTPage$totalResults(_LOGOS_SELF_TYPE_NORMAL YTPage* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {







    
    int orig = _logos_orig$_ungrouped$YTPage$totalResults(self, _cmd);
    NSLog(@"total results 2 = %i", orig);
    return orig;
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSURLConnection = objc_getClass("NSURLConnection"); Class _logos_metaclass$_ungrouped$NSURLConnection = object_getClass(_logos_class$_ungrouped$NSURLConnection); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSURLConnection, @selector(requestWithRequest:), (IMP)&_logos_meta_method$_ungrouped$NSURLConnection$requestWithRequest$, (IMP*)&_logos_meta_orig$_ungrouped$NSURLConnection$requestWithRequest$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSURLConnection, @selector(sendAsynchronousRequest:queue:completionHandler:), (IMP)&_logos_meta_method$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$, (IMP*)&_logos_meta_orig$_ungrouped$NSURLConnection$sendAsynchronousRequest$queue$completionHandler$);}Class _logos_class$_ungrouped$YTGDataService = objc_getClass("YTGDataService"); { MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(initWithOperationQueue:HTTPFetcherService:deviceAuthorizer:userAuthenticator:), (IMP)&_logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuthenticator$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(initWithOperationQueue:HTTPFetcherService:deviceAuthorizer:userAuth:requestFactory:), (IMP)&_logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$userAuth$requestFactory$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGDataService, @selector(initWithOperationQueue:HTTPFetcherService:deviceAuthorizer:requestFactory:), (IMP)&_logos_method$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$, (IMP*)&_logos_orig$_ungrouped$YTGDataService$initWithOperationQueue$HTTPFetcherService$deviceAuthorizer$requestFactory$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(YTCache*), strlen(@encode(YTCache*))); i += strlen(@encode(YTCache*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTGDataService, @selector(channelCache), (IMP)&_logos_method$_ungrouped$YTGDataService$channelCache, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(YTChannel*), strlen(@encode(YTChannel*))); i += strlen(@encode(YTChannel*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTGDataService, @selector(cacheChannel:), (IMP)&_logos_method$_ungrouped$YTGDataService$cacheChannel$, _typeEncoding); }Class _logos_class$_ungrouped$GIPSpeechController = objc_getClass("GIPSpeechController"); { MSHookMessageEx(_logos_class$_ungrouped$GIPSpeechController, @selector(serverURL), (IMP)&_logos_method$_ungrouped$GIPSpeechController$serverURL, (IMP*)&_logos_orig$_ungrouped$GIPSpeechController$serverURL);}Class _logos_class$_ungrouped$NSAssertionHandler = objc_getClass("NSAssertionHandler"); { MSHookMessageEx(_logos_class$_ungrouped$NSAssertionHandler, @selector(handleFailureInFunction:file:lineNumber:description:), (IMP)&_logos_method$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$, (IMP*)&_logos_orig$_ungrouped$NSAssertionHandler$handleFailureInFunction$file$lineNumber$description$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSAssertionHandler, @selector(handleFailureInMethod:object:file:lineNumber:description:), (IMP)&_logos_method$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$, (IMP*)&_logos_orig$_ungrouped$NSAssertionHandler$handleFailureInMethod$object$file$lineNumber$description$);}Class _logos_class$_ungrouped$YTItemListHeader = objc_getClass("YTItemListHeader"); { MSHookMessageEx(_logos_class$_ungrouped$YTItemListHeader, @selector(setItemCount:), (IMP)&_logos_method$_ungrouped$YTItemListHeader$setItemCount$, (IMP*)&_logos_orig$_ungrouped$YTItemListHeader$setItemCount$);}Class _logos_class$_ungrouped$YTPage = objc_getClass("YTPage"); { MSHookMessageEx(_logos_class$_ungrouped$YTPage, @selector(totalResults), (IMP)&_logos_method$_ungrouped$YTPage$totalResults, (IMP*)&_logos_orig$_ungrouped$YTPage$totalResults);}} }
#line 197 "googleapp/general.x"
