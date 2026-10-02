// Preferences.m
// TubeFixLegacy - link-time stand-in for the private Preferences.framework,
// only used when the SDK doesn't ship one to link against. The device's
// real framework provides these classes at runtime.
#import <UIKit/UIKit.h>

@interface PSViewController : UIViewController @end
@implementation PSViewController @end
@interface PSListController : PSViewController { NSMutableArray *_specifiers; } @end
@implementation PSListController @end
@interface PSSpecifier : NSObject @end
@implementation PSSpecifier @end
