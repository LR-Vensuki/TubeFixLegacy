#line 1 "googleapp/subtitles.x"
#import <Foundation/Foundation.h>
#import "appheaders.h"
#include "general.h"


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

@class YTTBXMLElement; @class YTSubtitlesService; @class YTBaseSubtitlesController; @class YTSubtitles; @class TBXML; @class YTSubtitlesParser; @class YTSubtitlesController; 
static void (*_logos_orig$_ungrouped$YTSubtitlesController$loadSubtitlesTracksWithBlock$)(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesController* _LOGOS_SELF_CONST, SEL, void (^)(id)); static void _logos_method$_ungrouped$YTSubtitlesController$loadSubtitlesTracksWithBlock$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesController* _LOGOS_SELF_CONST, SEL, void (^)(id)); static void (*_logos_orig$_ungrouped$YTBaseSubtitlesController$loadSubtitlesTracksWithBlock$)(_LOGOS_SELF_TYPE_NORMAL YTBaseSubtitlesController* _LOGOS_SELF_CONST, SEL, void (^)(id)); static void _logos_method$_ungrouped$YTBaseSubtitlesController$loadSubtitlesTracksWithBlock$(_LOGOS_SELF_TYPE_NORMAL YTBaseSubtitlesController* _LOGOS_SELF_CONST, SEL, void (^)(id)); static void (*_logos_orig$_ungrouped$YTSubtitlesService$makeSubtitlesRequestWithVideoID$track$responseBlock$errorBlock$)(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesService* _LOGOS_SELF_CONST, SEL, NSString*, YTSubtitlesTrack*, id, id); static void _logos_method$_ungrouped$YTSubtitlesService$makeSubtitlesRequestWithVideoID$track$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesService* _LOGOS_SELF_CONST, SEL, NSString*, YTSubtitlesTrack*, id, id); static id (*_logos_orig$_ungrouped$YTSubtitlesParser$parse$error$)(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesParser* _LOGOS_SELF_CONST, SEL, NSData*, NSError**); static id _logos_method$_ungrouped$YTSubtitlesParser$parse$error$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesParser* _LOGOS_SELF_CONST, SEL, NSData*, NSError**); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$TBXML(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("TBXML"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTTBXMLElement(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTTBXMLElement"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTSubtitles(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTSubtitles"); } return _klass; }
#line 5 "googleapp/subtitles.x"




static void _logos_method$_ungrouped$YTSubtitlesController$loadSubtitlesTracksWithBlock$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^responseBlock)(id)) {
    YTSubtitlesService *service = nil; 

    if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
        service = [(YTServices*)[self valueForKey:@"services_"] subtitlesService];
    } else {
        service = [self valueForKey:l(@"subtitlesService")];
    }
    
    NSArray *trackURLs = [(YTVideo*)[self valueForKey:l(@"video")] subtitlesTracksURL];

    [service performResponseBlock:^(id response)
    {
        if ([response count])
        {
            [self setSubtitlesTracks:response];
            responseBlock(response);
        }
    } response:trackURLs];
}







static void _logos_method$_ungrouped$YTBaseSubtitlesController$loadSubtitlesTracksWithBlock$(_LOGOS_SELF_TYPE_NORMAL YTBaseSubtitlesController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^responseBlock)(id)) {
    YTSubtitlesService *service = [self valueForKey:l(@"subtitlesService")];

    NSArray *trackURLs = nil;
    if ([version() characterAtIndex:0] == '1') { 
        trackURLs = [(YTVideo*)[self valueForKey:l(@"video")] subtitlesTracksURL];
    } else {
        trackURLs = [self valueForKey:@"_subtitlesTracksURL"];
    }

    [service performResponseBlock:^(id response)
    {
        if ([response count])
        {
            [self setSubtitlesTracks:response];
            responseBlock(response);
        }
    } response:trackURLs];
}






static void _logos_method$_ungrouped$YTSubtitlesService$makeSubtitlesRequestWithVideoID$track$responseBlock$errorBlock$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* videoId, YTSubtitlesTrack* track, id responseBlock, id errorBlock)  {












    NSURLRequest *request = [NSURLRequest requestWithURL:[track trackName]];
    [self performHTTPRequest:request parser:[self valueForKey:l(@"subtitlesParser")] responseBlock:responseBlock errorBlock:errorBlock];
  
}



@interface YTSubtitles : NSObject
{
    NSMutableArray *lines_;
}

- (id)textAtTime:(unsigned int)fp8;
- (void)appendLine:(id)fp8 startTime:(unsigned int)fp12 endTime:(unsigned int)fp16;
- (id)copyWithZone:(struct _NSZone *)fp8;
- (void)dealloc;
- (id)init;

@end




static id _logos_method$_ungrouped$YTSubtitlesParser$parse$error$(_LOGOS_SELF_TYPE_NORMAL YTSubtitlesParser* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData* data, NSError** error) {
    TBXML *xml = [_logos_static_class_lookup$TBXML() tbxmlWithXMLData:data error:error];
    if ([xml rootXMLElement]) {        
        YTTBXMLElement *root = [[[_logos_static_class_lookup$YTTBXMLElement() alloc] 
                        initWithElement:[xml rootXMLElement]] autorelease];
        
        
        
        YTSubtitles *subtitles = [[[_logos_static_class_lookup$YTSubtitles() alloc] init] autorelease];
        if (root) {            
            
            YTTBXMLElement *bodyElement = [root childElementNamed:@"body"];
            
            if (bodyElement) {
                
                YTTBXMLElement *textBlock = [bodyElement childElementNamed:@"p"];
                
                double previousEnd = 0;
                double previousStart = 0;
                NSString *previousText = nil;

                while (textBlock != nil) {
                    
                    double start = [[textBlock valueOfAttributeNamed:@"t"] doubleValue];
                    double dur = [[textBlock valueOfAttributeNamed:@"d"] doubleValue];
                    double endDuration = start + dur;

                    NSString *textContent = [textBlock text];

                    if ([textContent isEqualToString:@""]) {
                        YTTBXMLElement *wordElement = [textBlock childElementNamed:@"s"];

                        while (wordElement != nil) { 
                            if (textContent) {
                                textContent = [NSString stringWithFormat:@"%@ %@",textContent, [wordElement text]];
                            } else {
                                textContent = [wordElement text];
                            }
                            wordElement = [wordElement nextSiblingNamed:@"s"];
                        }
                    }
                    
                    NSError *error = nil;
                    
                    if (textContent) {
                        
                        NSRegularExpression *regex = [NSRegularExpression 
                            regularExpressionWithPattern:@"<[^>]+>"
                            options:NSRegularExpressionCaseInsensitive 
                            error:&error];
                        textContent = [regex stringByReplacingMatchesInString:textContent
                            options:0
                            range:NSMakeRange(0, [textContent length])
                            withTemplate:@""];
                            
                        
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
                        textContent = [textContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    }
                    

                    if (previousText) {
                        if (previousEnd >= start) {
                            previousEnd = start-0.001;
                        }
                        [subtitles appendLine:previousText startTime:previousStart endTime:previousEnd];
                    }
                    
                    previousStart = start;
                    previousEnd = endDuration;
                    previousText = textContent;                
                    
                    
                    
                    
                    textBlock = [textBlock nextSiblingNamed:@"p"];
                }
                if (previousText)
                    [subtitles appendLine:previousText startTime:previousStart endTime:previousEnd];

            } else {
                
                YTTBXMLElement *textElement = [root childElementNamed:@"text"];
                
                double previousEnd = 0;
                double previousStart = 0;
                NSString *previousText = nil;

                while (textElement != nil) {
                    
                    double start = [[textElement valueOfAttributeNamed:@"start"] doubleValue]*1000;
                    double dur = [[textElement valueOfAttributeNamed:@"dur"] doubleValue]*1000;
                    double endDuration = start + dur;
                    NSString *textContent = [textElement text];
                    NSError *error = nil;

                    
                    NSRegularExpression *regex = [NSRegularExpression 
                        regularExpressionWithPattern:@"<[^>]+>"
                        options:NSRegularExpressionCaseInsensitive 
                        error:&error];
                    textContent = [regex stringByReplacingMatchesInString:textContent
                        options:0
                        range:NSMakeRange(0, [textContent length])
                        withTemplate:@""];

                    
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
                    textContent = [textContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

                    if (previousText) {
                        if (previousEnd >= start) {
                            previousEnd = start-0.001;
                        }
                        [subtitles appendLine:previousText startTime:previousStart endTime:previousEnd];
                    }
                    
                    previousStart = start;
                    previousEnd = endDuration;
                    previousText = textContent;                
                    
                    
                    
                    
                    textElement = [textElement nextSiblingNamed:@"text"];
                }
                if (previousText)
                    [subtitles appendLine:previousText startTime:previousStart endTime:previousEnd];
            }

        }
        return subtitles;
    } else {
        NSLog(@"Failed to decode XML subtitles!!!!");
        return nil;
    }
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTSubtitlesController = objc_getClass("YTSubtitlesController"); { MSHookMessageEx(_logos_class$_ungrouped$YTSubtitlesController, @selector(loadSubtitlesTracksWithBlock:), (IMP)&_logos_method$_ungrouped$YTSubtitlesController$loadSubtitlesTracksWithBlock$, (IMP*)&_logos_orig$_ungrouped$YTSubtitlesController$loadSubtitlesTracksWithBlock$);}Class _logos_class$_ungrouped$YTBaseSubtitlesController = objc_getClass("YTBaseSubtitlesController"); { MSHookMessageEx(_logos_class$_ungrouped$YTBaseSubtitlesController, @selector(loadSubtitlesTracksWithBlock:), (IMP)&_logos_method$_ungrouped$YTBaseSubtitlesController$loadSubtitlesTracksWithBlock$, (IMP*)&_logos_orig$_ungrouped$YTBaseSubtitlesController$loadSubtitlesTracksWithBlock$);}Class _logos_class$_ungrouped$YTSubtitlesService = objc_getClass("YTSubtitlesService"); { MSHookMessageEx(_logos_class$_ungrouped$YTSubtitlesService, @selector(makeSubtitlesRequestWithVideoID:track:responseBlock:errorBlock:), (IMP)&_logos_method$_ungrouped$YTSubtitlesService$makeSubtitlesRequestWithVideoID$track$responseBlock$errorBlock$, (IMP*)&_logos_orig$_ungrouped$YTSubtitlesService$makeSubtitlesRequestWithVideoID$track$responseBlock$errorBlock$);}Class _logos_class$_ungrouped$YTSubtitlesParser = objc_getClass("YTSubtitlesParser"); { MSHookMessageEx(_logos_class$_ungrouped$YTSubtitlesParser, @selector(parse:error:), (IMP)&_logos_method$_ungrouped$YTSubtitlesParser$parse$error$, (IMP*)&_logos_orig$_ungrouped$YTSubtitlesParser$parse$error$);}} }
#line 244 "googleapp/subtitles.x"
