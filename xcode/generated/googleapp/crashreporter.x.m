#line 1 "googleapp/crashreporter.x"
#import <Foundation/Foundation.h>
#import "appheaders.h"
#import "common/Protobuf.h"
#import "general.h"
#import <execinfo.h>
#import <mach-o/dyld.h>

@interface SomeProtobufClassIDontWantToRE

-(NSData*)data;

@end

@interface GIPFeedbackCollectedData

-(id)crashReport;
-(SomeProtobufClassIDontWantToRE*)exportAsProto;

@end

@interface GIPCrashReportData

-(void)setReportStatus:(int)a1;

@end

@interface GIPFeedback

-(BOOL)hasInternetConnection;

@end


@interface GIPFeedbackLocalizedString

+(id)sendMessageString;
+(id)sendMessageLaterString;

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

@class GIPToast; @class GIPFeedback; 
static void (*_logos_meta_orig$_ungrouped$GIPFeedback$submitFeedbackWithCollectedData$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, GIPFeedbackCollectedData *); static void _logos_meta_method$_ungrouped$GIPFeedback$submitFeedbackWithCollectedData$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, GIPFeedbackCollectedData *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$GIPToast(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("GIPToast"); } return _klass; }
#line 46 "googleapp/crashreporter.x"



static void _logos_meta_method$_ungrouped$GIPFeedback$submitFeedbackWithCollectedData$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GIPFeedbackCollectedData * collectedData) {
    GIPCrashReportData *crashReport = [collectedData crashReport];

    NSData *postData = [[collectedData exportAsProto] data];

    
    ProtobufEncoder *pb = [[ProtobufEncoder alloc] initWithExistingData:postData];
    [pb writeMessageField:5 usingBlock:^(ProtobufEncoder *tbSpecific) {
        [tbSpecific writeStringField:1 string:TRPackageVersion(@"com.legacyreborn.tubefixlegacy") ?: @"unknown"];
    }];
    NSData *report = [pb dataRepresentation];

    NSString *directory = @"/var/mobile/Library/Logs/TubeFixLegacy";
    [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HHmmss"];
    NSString *path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"feedback-%@-YouTube-%@.pb", [formatter stringFromDate:[NSDate date]], version()]];
    [formatter release];
    BOOL saved = [report writeToFile:path atomically:YES];
    [pb release];

    [crashReport setReportStatus:(saved ? 1 : 2)];
    [_logos_static_class_lookup$GIPToast() showToast:(saved ? @"Report saved to Logs/TubeFixLegacy" : @"Couldn't save the report") forDuration:3.0];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"kGIPFeedbackDidSubmitFeedbackNotification"
                      object:self];
}







































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$GIPFeedback = objc_getClass("GIPFeedback"); Class _logos_metaclass$_ungrouped$GIPFeedback = object_getClass(_logos_class$_ungrouped$GIPFeedback); { MSHookMessageEx(_logos_metaclass$_ungrouped$GIPFeedback, @selector(submitFeedbackWithCollectedData:), (IMP)&_logos_meta_method$_ungrouped$GIPFeedback$submitFeedbackWithCollectedData$, (IMP*)&_logos_meta_orig$_ungrouped$GIPFeedback$submitFeedbackWithCollectedData$);}} }
#line 116 "googleapp/crashreporter.x"
