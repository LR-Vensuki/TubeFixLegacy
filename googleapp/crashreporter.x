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

// The app's "Send feedback" / crash report button used to post to
// Google; TubeReplacer redirected it to its author's server. This fork
// keeps the report on the device instead, in
// /var/mobile/Library/Logs/TubeFixLegacy/, so it can be attached to a bug
// report by hand.
%hook GIPFeedback

+ (void)submitFeedbackWithCollectedData:(GIPFeedbackCollectedData *)collectedData
{
    GIPCrashReportData *crashReport = [collectedData crashReport];

    NSData *postData = [[collectedData exportAsProto] data];

    // add the tweak version to the protobuf, as before
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
    [%c(GIPToast) showToast:(saved ? @"Report saved to Logs/TubeFixLegacy" : @"Couldn't save the report") forDuration:3.0];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"kGIPFeedbackDidSubmitFeedbackNotification"
                      object:self];
}

%end

// %hook GIPFeedbackCrashReportHandler

// - (id)initWithViewController:(id)controller categoryTag:(id)categoryTag
// {
//     intptr_t slide = _dyld_get_image_vmaddr_slide(0);
//     NSLog(@"ASLR Slide Offset: 0x%lx", (unsigned long)slide);

//     NSLog(@"controller = %@", controller);
//     NSLog(@"controller class = %@", [controller class]);

//     void *callstack[128];
//     int frames = backtrace(callstack, 128);
//     char **symbols = backtrace_symbols(callstack, frames);

//     NSMutableString *callstackString =
//         [NSMutableString stringWithString:@"uwu >_<"];

//     for (int i = 0; i < frames; i++)
//         [callstackString appendFormat:@"%s\n", symbols[i]];

//     free(symbols);

//     NSLog(@"%@", callstackString);

//     return %orig(controller, categoryTag);
// }

// - (void)alertView:(id)alertView clickedButtonAtIndex:(int)clickedButtonIndex
// {
//     NSLog(@"alert aaaaaaa");
//     NSLog(@"view controller -> %@", [self valueForKey:@"viewController_"]);

//     %orig(alertView, clickedButtonIndex);
// }

// %end