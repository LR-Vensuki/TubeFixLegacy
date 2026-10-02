#line 1 "googleapp/infooverflowfix.x"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "appheaders.h"
#import "general.h"

static const void *kTRLikeObserverAddedKey = &kTRLikeObserverAddedKey;
static const void *kTRLikeCurrentVideoKey = &kTRLikeCurrentVideoKey;



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

@class YTUtils; @class YTAttributedTextLabel; @class YTVideoInfoLeftView_iPad; @class YTVideoInfoCell; @class YTColor; @class YTUIUtils; @class YTVideoInfoCell_iPhone; 
static id (*_logos_meta_orig$_ungrouped$YTUtils$localizedCount$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, uint64_t); static id _logos_meta_method$_ungrouped$YTUtils$localizedCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, uint64_t); static id (*_logos_meta_orig$_ungrouped$YTUIUtils$localizedCount$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, uint64_t); static id _logos_meta_method$_ungrouped$YTUIUtils$localizedCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, uint64_t); static void (*_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, BOOL); static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, BOOL); static void (*_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL, int, BOOL); static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL, int, BOOL); static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$tr_likeStateDidChange$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL, NSNotification*); static void (*_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$dealloc(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoLeftView_iPad* _LOGOS_SELF_CONST, SEL, YTVideo*); static void _logos_method$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoLeftView_iPad* _LOGOS_SELF_CONST, SEL, YTVideo*); static void (*_logos_orig$_ungrouped$YTVideoInfoCell$setVideo$userLike$userDislike$)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, BOOL); static void _logos_method$_ungrouped$YTVideoInfoCell$setVideo$userLike$userDislike$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST, SEL, YTVideo*, BOOL, BOOL); static void _logos_method$_ungrouped$YTVideoInfoCell$tr_likeStateDidChange$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST, SEL, NSNotification*); static void (*_logos_orig$_ungrouped$YTVideoInfoCell$dealloc)(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTVideoInfoCell$dealloc(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTColor(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTColor"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTUIUtils(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTUIUtils"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTAttributedTextLabel(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTAttributedTextLabel"); } return _klass; }
#line 10 "googleapp/infooverflowfix.x"


static id _logos_meta_method$_ungrouped$YTUtils$localizedCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, uint64_t number) {
  return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:number] numberStyle:1];
}




static id _logos_meta_method$_ungrouped$YTUIUtils$localizedCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, uint64_t number) {
    
  return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:number] numberStyle:1];
}


@interface YTLikesDislikesView : NSObject
- (void)setVideo:(id)video userLike:(BOOL)userLike userDislike:(BOOL)userDislike;
-(void)sizeToFit;
@end




static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, BOOL userLike, BOOL userDislike) {
    
    
    
    
    
    
    BOOL resolvedLike = userLike;
    BOOL resolvedDislike = userDislike;
    TRResolveLikeDislike([video ID], userLike, userDislike, &resolvedLike, &resolvedDislike);
    userLike = resolvedLike;
    userDislike = resolvedDislike;

    objc_setAssociatedObject(self, kTRLikeCurrentVideoKey, video, OBJC_ASSOCIATION_RETAIN);
    if (![objc_getAssociatedObject(self, kTRLikeObserverAddedKey) boolValue]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(tr_likeStateDidChange:)
                                                      name:TRLikeStateDidChangeNotification
                                                    object:nil];
        objc_setAssociatedObject(self, kTRLikeObserverAddedKey, @YES, OBJC_ASSOCIATION_RETAIN);
    }

    if ([version() isEqualToString:@"1.1.0"] || [version() isEqualToString:@"1.2.1"]) {
        return _logos_orig$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$(self, _cmd, video, userLike, userDislike);
    }
  
  [(UILabel*)[self valueForKey:l(@"titleLabel")] setText:[video title]];

  
  NSDate *uploadedDate = nil;
  if ([video publishedDate])
    uploadedDate = [video publishedDate];
  else
    uploadedDate = [video uploadedDate];

  NSString *formattedUploadDate = [NSDateFormatter localizedStringFromDate:uploadedDate dateStyle:2 timeStyle:0];

  [(UILabel*)[self valueForKey:l(@"dateLabel")] setText:[NSString stringWithFormat:localizedStringForKey(@"video_info.published_date"), formattedUploadDate]];

  [(YTLikesDislikesView*)[self valueForKey:l(@"likesDislikesView")] setVideo:video userLike:userLike userDislike:userDislike];
  if ([video videoDescription])
  {
    [(UILabel*)[self valueForKey:l(@"descriptionLabel")] setText:[video videoDescription]];
  }

  if ( ![video isLive] )
  {
    
    
    
    
    

      

        [(YTAttributedTextLabel*)[self valueForKey:l(@"viewCountLabel")] clearText];
        if ( ![video isLive] || [video viewCount] )
        {
            NSString *formattedCount = [_logos_static_class_lookup$YTUIUtils() localizedCount:[video viewCount]];
            NSString *localizationKey;
            if ( [video isLive] )
                localizationKey = @"video_info.live_viewers";
            else
                localizationKey = @"video_info.views";
            NSString *viewCountText = localizedStringForKey2(localizationKey, [video viewCount]);

            [(YTAttributedTextLabel*)[self valueForKey:l(@"viewCountLabel")] appendText:[formattedCount stringByAppendingString:@"\n"]
                                   withAttributes:[_logos_static_class_lookup$YTAttributedTextLabel() attributesWithFont:[UIFont mediumLightFont] color:[_logos_static_class_lookup$YTColor() XDarkTextColor] paragraphSpacingBefore:0 textAlignment:1]
                                ];

            [(YTAttributedTextLabel*)[self valueForKey:l(@"viewCountLabel")] appendText:viewCountText 
                                                           withAttributes:[_logos_static_class_lookup$YTAttributedTextLabel() attributesWithFont:[UIFont XSmallLightFont] color:[_logos_static_class_lookup$YTColor() mediumTextColor] paragraphSpacingBefore:0 textAlignment:1]
                                                    ];
        }
  }
  [self setValue:@1 forKey:l(@"layoutChanged")];
  [self setNeedsLayout];
}


static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int viewCount, BOOL isLive) {
    NSLog(@"updateViewCountLabelWithViewCount was called! This function should hopefully no longer be called, as it has a 32bit limit.");
    return _logos_orig$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$(self, _cmd, viewCount, isLive);
}



static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$tr_likeStateDidChange$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification* note) {
    YTVideo *currentVideo = objc_getAssociatedObject(self, kTRLikeCurrentVideoKey);
    if (!currentVideo || ![[currentVideo ID] isEqualToString:(NSString*)[note object]]) {
        return;
    }
    
    
    
    
    [self setVideo:currentVideo userLike:NO userDislike:NO];
}


static void _logos_method$_ungrouped$YTVideoInfoCell_iPhone$dealloc(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell_iPhone* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _logos_orig$_ungrouped$YTVideoInfoCell_iPhone$dealloc(self, _cmd);
}



static void _logos_method$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoLeftView_iPad* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video) {
    if ([version() isEqualToString:@"1.1.0"] || [version() isEqualToString:@"1.2.1"]) {
        return _logos_orig$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$(self, _cmd, video);
    }

    [[self valueForKey:l(@"video")] autorelease];
    [self setValue:[video retain] forKey:l(@"video")];
    [(UILabel*)[self valueForKey:l(@"titleLabel")] setText:[video title]];

    NSDate *uploadedDate;
    if ([video publishedDate])
        uploadedDate = [video publishedDate];
    else
        uploadedDate = [video uploadedDate];
    
    [(UILabel*)[self valueForKey:l(@"dateLabel")] setText:[NSString stringWithFormat:localizedStringForKey(@"video_info.published_date"),
                        [NSDateFormatter localizedStringFromDate:uploadedDate dateStyle:2 timeStyle:0]
                    ]];
    [(UILabel*)[self valueForKey:l(@"dateLabel")] sizeToFit];
    [(UILabel*)[self valueForKey:l(@"viewsLabel")] setText:@""];
    if (![video isLive])
    {
        NSString *localizationKey = nil;
        if ( ![video isLive] )
            localizationKey = @"video_info.num_views";
        
        else
            localizationKey = @"video_info.live_viewers";
    
        [(UILabel*)[self valueForKey:l(@"viewsLabel")] setText:[NSString stringWithFormat:localizedStringForKey2UILib(localizationKey, [video viewCount]), [_logos_static_class_lookup$YTUIUtils() localizedCount:[video viewCount]]]];
        [(UILabel*)[self valueForKey:l(@"viewsLabel")] sizeToFit];
        
        
        
        
        
    }
    BOOL resolvedLike = NO, resolvedDislike = NO;
    TRResolveLikeDislike([video ID], NO, NO, &resolvedLike, &resolvedDislike);
    [(YTLikesDislikesView*)[self valueForKey:l(@"likesDislikesView")] setVideo:video userLike:resolvedLike userDislike:resolvedDislike];
    [(YTLikesDislikesView*)[self valueForKey:l(@"likesDislikesView")] sizeToFit];
    if ([video videoDescription]) {
        [(NIAttributedLabel*)[self valueForKey:@"descriptionLabel"] setText:[video videoDescription]];
    }
}







static void _logos_method$_ungrouped$YTVideoInfoCell$setVideo$userLike$userDislike$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, YTVideo* video, BOOL userLike, BOOL userDislike) {
    BOOL resolvedLike = userLike;
    BOOL resolvedDislike = userDislike;
    TRResolveLikeDislike([video ID], userLike, userDislike, &resolvedLike, &resolvedDislike);
    userLike = resolvedLike;
    userDislike = resolvedDislike;

    objc_setAssociatedObject(self, kTRLikeCurrentVideoKey, video, OBJC_ASSOCIATION_RETAIN);
    if (![objc_getAssociatedObject(self, kTRLikeObserverAddedKey) boolValue]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(tr_likeStateDidChange:)
                                                      name:TRLikeStateDidChangeNotification
                                                    object:nil];
        objc_setAssociatedObject(self, kTRLikeObserverAddedKey, @YES, OBJC_ASSOCIATION_RETAIN);
    }

    [(UILabel*)[self valueForKey:l(@"titleLabel")] setText:[video title]];

    NSDate *publishedDate;
    if ([video publishedDate])
        publishedDate = [video publishedDate];
    else
        publishedDate = [video uploadedDate];

    NSString *formattedDate = [NSDateFormatter localizedStringFromDate:publishedDate dateStyle:2 timeStyle:0];

    
    [(YTLikesDislikesView*)[self valueForKey:l(@"likesDislikesView")] setVideo:video userLike:userLike userDislike:userDislike];

    int datePostedLength = [formattedDate length];
    if ( [[video videoDescription] length] )
    {
        [(NIAttributedLabel*)[self valueForKey:l(@"descriptionLabel")] setText:[NSString stringWithFormat:@"%@  ·  %@", formattedDate, [video videoDescription]]];
        datePostedLength += 3;
    }
    else
    {
        [(NIAttributedLabel*)[self valueForKey:l(@"descriptionLabel")] setText:formattedDate];
    }
    [(NIAttributedLabel*)[self valueForKey:l(@"descriptionLabel")] setTextColor:[_logos_static_class_lookup$YTColor() XDarkTextColor] range:NSMakeRange(0, datePostedLength)];
    if (![video isLive])
    {
        [(UILabel*)[self valueForKey:l(@"viewCountLabel")] setText:nil];
        if ( ![video isLive] || [video viewCount] )
        {
            NSString *formattedCount = [_logos_static_class_lookup$YTUIUtils() localizedCount:[video viewCount]];
            NSString *viewCountText;
            if ( [video isLive] )
                viewCountText = localizedStringForKey2(@"video_info.live_viewers", [video viewCount]);
            else
                viewCountText = localizedStringForKey2(@"video_info.views", [video viewCount]);

            [(UILabel*)[self valueForKey:l(@"viewCountLabel")] setText:[NSString stringWithFormat:@"%@ %@", formattedCount, viewCountText]];
            
        }
    }
    [self setNeedsLayout];
}



static void _logos_method$_ungrouped$YTVideoInfoCell$tr_likeStateDidChange$(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification* note) {
    YTVideo *currentVideo = objc_getAssociatedObject(self, kTRLikeCurrentVideoKey);
    if (!currentVideo || ![[currentVideo ID] isEqualToString:(NSString*)[note object]]) {
        return;
    }
    [self setVideo:currentVideo userLike:NO userDislike:NO];
}


static void _logos_method$_ungrouped$YTVideoInfoCell$dealloc(_LOGOS_SELF_TYPE_NORMAL YTVideoInfoCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _logos_orig$_ungrouped$YTVideoInfoCell$dealloc(self, _cmd);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTUtils = objc_getClass("YTUtils"); Class _logos_metaclass$_ungrouped$YTUtils = object_getClass(_logos_class$_ungrouped$YTUtils); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTUtils, @selector(localizedCount:), (IMP)&_logos_meta_method$_ungrouped$YTUtils$localizedCount$, (IMP*)&_logos_meta_orig$_ungrouped$YTUtils$localizedCount$);}Class _logos_class$_ungrouped$YTUIUtils = objc_getClass("YTUIUtils"); Class _logos_metaclass$_ungrouped$YTUIUtils = object_getClass(_logos_class$_ungrouped$YTUIUtils); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTUIUtils, @selector(localizedCount:), (IMP)&_logos_meta_method$_ungrouped$YTUIUtils$localizedCount$, (IMP*)&_logos_meta_orig$_ungrouped$YTUIUtils$localizedCount$);}Class _logos_class$_ungrouped$YTVideoInfoCell_iPhone = objc_getClass("YTVideoInfoCell_iPhone"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoCell_iPhone, @selector(setVideo:userLike:userDislike:), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$setVideo$userLike$userDislike$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoCell_iPhone, @selector(updateViewCountLabelWithViewCount:isLive:), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$updateViewCountLabelWithViewCount$isLive$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification*), strlen(@encode(NSNotification*))); i += strlen(@encode(NSNotification*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTVideoInfoCell_iPhone, @selector(tr_likeStateDidChange:), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell_iPhone$tr_likeStateDidChange$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoCell_iPhone, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell_iPhone$dealloc, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoCell_iPhone$dealloc);}Class _logos_class$_ungrouped$YTVideoInfoLeftView_iPad = objc_getClass("YTVideoInfoLeftView_iPad"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoLeftView_iPad, @selector(setVideo:), (IMP)&_logos_method$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoLeftView_iPad$setVideo$);}Class _logos_class$_ungrouped$YTVideoInfoCell = objc_getClass("YTVideoInfoCell"); { MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoCell, @selector(setVideo:userLike:userDislike:), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell$setVideo$userLike$userDislike$, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoCell$setVideo$userLike$userDislike$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification*), strlen(@encode(NSNotification*))); i += strlen(@encode(NSNotification*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTVideoInfoCell, @selector(tr_likeStateDidChange:), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell$tr_likeStateDidChange$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$YTVideoInfoCell, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$YTVideoInfoCell$dealloc, (IMP*)&_logos_orig$_ungrouped$YTVideoInfoCell$dealloc);}} }
#line 268 "googleapp/infooverflowfix.x"
