#line 1 "googleapp/videostats.x"
#import "appheaders.h"
#import "general.h"


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

@class YTVideoStatsService; 
static void (*_logos_orig$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$)(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST, SEL, GTMURLBuilder*); static void _logos_method$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST, SEL, GTMURLBuilder*); static void (*_logos_orig$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$)(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST, SEL, id); 

#line 4 "googleapp/videostats.x"

static void _logos_method$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, GTMURLBuilder* builder) {
    _logos_orig$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$(self, _cmd, builder);
    NSDictionary *videoStatsInfo = objc_getAssociatedObject([self valueForKey:l(@"video")], "videoStatsInfo");
    for (NSString *queryKey in [videoStatsInfo allKeys]) {
        [builder setValue:videoStatsInfo[queryKey] forParameter:queryKey];
    }
}

static void _logos_method$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$(_LOGOS_SELF_TYPE_NORMAL YTVideoStatsService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id builder) {
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
    if ([preferences[@"EnableVideoStats"] isEqual:@(YES)] || preferences[@"EnableVideoStats"] == nil) {
        return _logos_orig$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$(self, _cmd, builder);
    }
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTVideoStatsService = objc_getClass("YTVideoStatsService"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoStatsService, @selector(setCommonVSSParametersToBuilder:), (IMP)&_logos_method$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$, (IMP*)&_logos_orig$_ungrouped$YTVideoStatsService$setCommonVSSParametersToBuilder$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTVideoStatsService, @selector(performSignedHTTPRequestWithBuilder:), (IMP)&_logos_method$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$, (IMP*)&_logos_orig$_ungrouped$YTVideoStatsService$performSignedHTTPRequestWithBuilder$);}} }
#line 21 "googleapp/videostats.x"
