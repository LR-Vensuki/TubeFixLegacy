// network.x
// TubeFixLegacy
//
// Request timeout: the app gives every API request 8 seconds. Through a VPN or a slow connection an
// iPhone 4/4S often needs longer just for the TLS handshake with
// www.youtube.com, and the app then shows "Error loading". Give requests
// at least 30 seconds.
//
// With "Verbose Logging" on, every failed YouTube API request is written
// to the system log with its URL and error, so "Error loading" in the app
// can be told apart from a network problem.
// -[YTGDataService makeCustomRequest:method:parser:responseBlock:errorBlock:]
// is where the app's GET/POST/DELETE helpers all end up (1.0.0 - 1.4.0).

#import <Foundation/Foundation.h>
#import "general.h"

@protocol TFLDiagnosticsRequest
- (id)URL;
@end

static const double kTFLMinimumRequestTimeout = 30.0;

// The app's own NSURLRequest(YTURLRequest) category builds every API
// request; +defaultRequestWithURL: and +defaultMutableRequestWithURL:
// hard-code 8 seconds (checked in the 1.4.0 binary).
%hook NSURLRequest

+ (id)defaultRequestWithURL:(NSURL *)url timeout:(double)timeout
{
    return %orig(url, timeout < kTFLMinimumRequestTimeout ? kTFLMinimumRequestTimeout : timeout);
}

+ (id)defaultMutableRequestWithURL:(NSURL *)url
{
    id request = %orig;
    if ([request isKindOfClass:[NSMutableURLRequest class]] && [request timeoutInterval] < kTFLMinimumRequestTimeout) {
        [(NSMutableURLRequest *)request setTimeoutInterval:kTFLMinimumRequestTimeout];
    }
    return request;
}

%end

%hook YTGDataService

- (void)makeCustomRequest:(id)request method:(id)method parser:(id)parser responseBlock:(id)responseBlock errorBlock:(id)errorBlock
{
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
    %orig(request, method, parser, responseBlock, errorBlock);
}

%end

%ctor {
    if (TRShouldLoadGoogleHooks()) {
        %init;
    }
}
