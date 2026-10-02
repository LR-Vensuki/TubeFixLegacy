#include "appheaders.h"
#include "general.h"
#import "../common/TRVersionSupport.h"
#import "sys/utsname.h"
#import <objc/runtime.h>

@interface NSURLConnection(YouTube)

+(NSString*)userAgent;
+(NSMutableURLRequest*)requestWithRequest:(NSURLRequest*)request;

@end

%hook NSURLConnection 

// so youtube is uhhhh
+(NSMutableURLRequest*)requestWithRequest:(NSURLRequest*)request
{
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

+(void)sendAsynchronousRequest:(NSURLRequest*)request queue:(id)queue completionHandler:(id)completionHandler
{
    %orig([[NSURLConnection requestWithRequest:request] autorelease], queue, completionHandler);
}
%end

// TubeReplacer reported every install/update (device model, iOS and app
// version, language, country) to its author's server. TubeFixLegacy is a
// separate fork and doesn't phone home.
static void analytics() {
}

static void compat_check() {
    // ipad ios 9+ check
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

%hook YTGDataService
-(YTGDataService*)initWithOperationQueue:(id)a3 HTTPFetcherService:(id)a4 deviceAuthorizer:(id)a5 userAuthenticator:(id)a6 {
    id orig = %orig();
    compat_check();
    analytics();
    if (orig) {
        objc_setAssociatedObject(orig, @"channelCache_", [[%c(YTCache) alloc] initWithExpirationInterval:1086070784 countLimit:500], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}

// 1.1.0
-(YTGDataService*)initWithOperationQueue:(id)a3 HTTPFetcherService:(id)a4 deviceAuthorizer:(id)a5 userAuth:(id)a6 requestFactory:(id)a7 {
    id orig = %orig();
    compat_check();
    analytics();
    if (orig) {
        objc_setAssociatedObject(orig, @"channelCache_", [[%c(YTCache) alloc] initWithExpirationInterval:1086070784 countLimit:500], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}

// 1.2.1+
-(YTGDataService*)initWithOperationQueue:(id)a3 HTTPFetcherService:(id)a4 deviceAuthorizer:(id)a5 requestFactory:(id)a7 {
    id orig = %orig();
    compat_check();
    analytics();
    if (orig) {
        id channelCache = [[%c(YTCache) alloc] initWithExpirationInterval:1086070784 countLimit:500];
        objc_setAssociatedObject(orig, @"channelCache_", channelCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orig;
}

%new
-(YTCache*)channelCache {
    return objc_getAssociatedObject(self, @"channelCache_");
}

%new
- (void)cacheChannel:(YTChannel*)channel
{
//     for (id entry in [channel entries]) {
//         id video = [entry video]; 
    if (channel) {
        [[self channelCache] setObject:channel forKey:[channel channelID]];
    }

    // }
}


%end

%hook GIPSpeechController 

-(NSString*)serverURL
{
  return @"http://www.google.com/m/voice-search"; // this may be useful for debugging it later, but it's C++ bullshit that frankly, i don't wanna deal with.
}
    
%end


%hook NSAssertionHandler
    
- (void) handleFailureInFunction:(NSString *) functionName 
                            file:(NSString *) fileName 
                      lineNumber:(NSInteger) line 
                     description:(NSString *) format {
    NSLog(@"Assert failed! Function %@ @ %@:%i, %@",functionName,fileName,(int)line,format);
    return %orig;
}

- (void)handleFailureInMethod:(SEL)selector 
                        object:(id)object 
                          file:(NSString *)fileName 
                    lineNumber:(NSInteger)line 
                   description:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    NSLog(@"[GTM-Assert-Hook] Method: %@ | File: %@:%ld | Error: %@", 
          NSStringFromSelector(selector), 
          fileName.lastPathComponent, 
          (long)line, 
          description);

    %orig;
}

%end

%hook YTItemListHeader
-(void)setItemCount:(unsigned int)count
{
    // NSLog(@"the count is %i",count);
    if (count == 2147483647) return;
    return %orig;
}
%end
#import <execinfo.h>



%hook YTPage 
-(int)totalResults
{
//       void *callstack[128];
//   int frames = backtrace(callstack, 128);
//   char **symbols = backtrace_symbols(callstack, frames);
//   NSMutableString *callstackString = [NSMutableString stringWithFormat:@"uwu >_<"];
//   for (int i = 0; i < frames; i++) {
//   [callstackString appendFormat:@"%s\n", symbols[i]];
//   }
    // NSLog(@"%@", callstackString);
    int orig = %orig;
    NSLog(@"total results 2 = %i", orig);
    return orig;
}
%end