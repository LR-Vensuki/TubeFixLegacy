#line 1 "googleapp/doubletapseek.x"




















#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "general.h"
#import "TRPlayback.h"
#import "TRSeekIndicatorView.h"


static const NSTimeInterval kTRSeekAccumulationWindow = 1.5;

static const void *kTRDoubleTapHandlerKey = &kTRDoubleTapHandlerKey;

@interface TRDoubleTapSeekHandler : NSObject <UIGestureRecognizerDelegate>
{
    UIView *_playerView; 
    UITapGestureRecognizer *_recognizer;
    TRSeekIndicatorView *_indicator;
    NSTimer *_resetTimer;
    TRSeekDirection _lastDirection;
    int _accumulatedSeconds;
}
- (id)initWithPlayerView:(UIView *)playerView;
- (void)attachToSingleTapRecognizers;
@end

@implementation TRDoubleTapSeekHandler


- (id)initWithPlayerView:(UIView *)playerView {
    self = [super init];
    if (self) {
        _playerView = playerView;

        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        _recognizer.numberOfTapsRequired = 2;
        _recognizer.delegate = self;
        _recognizer.cancelsTouchesInView = NO;
        [playerView addGestureRecognizer:_recognizer];

        _indicator = [[TRSeekIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
        [playerView addSubview:_indicator];
    }
    return self;
}

static void TRCollectSingleTapRecognizers(UIView *view, NSMutableArray *recognizers, int depth) {
    if (!view || depth > 8) {
        return;
    }
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]] && [(UITapGestureRecognizer *)recognizer numberOfTapsRequired] == 1) {
            [recognizers addObject:recognizer];
        }
    }
    for (UIView *subview in view.subviews) {
        
        if (![subview isKindOfClass:[UIControl class]]) {
            TRCollectSingleTapRecognizers(subview, recognizers, depth + 1);
        }
    }
}




- (void)attachToSingleTapRecognizers {
    NSMutableArray *recognizers = [NSMutableArray array];
    TRCollectSingleTapRecognizers(_playerView, recognizers, 0);
    for (UIGestureRecognizer *recognizer in recognizers) {
        if (recognizer == _recognizer) {
            continue;
        }
        if (!objc_getAssociatedObject(recognizer, kTRDoubleTapHandlerKey)) {
            [recognizer requireGestureRecognizerToFail:_recognizer];
            objc_setAssociatedObject(recognizer, kTRDoubleTapHandlerKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            TFLLog(@"double tap: single tap %@ on %@ now waits for it", recognizer, NSStringFromClass([recognizer.view class]));
        }
    }
    _recognizer.enabled = TRDoubleTapSeekEnabled();
}


- (void)resetAccumulator {
    _accumulatedSeconds = 0;
    [_resetTimer release];
    _resetTimer = nil;
}


- (void)didDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateEnded || !TRDoubleTapSeekEnabled()) {
        return;
    }

    int step = TRDoubleTapSeekSeconds();
    TFLLog(@"double tap at %@ in %@", NSStringFromCGPoint([recognizer locationInView:_playerView]), NSStringFromCGRect(_playerView.bounds));
    CGPoint location = [recognizer locationInView:_playerView];
    CGSize size = _playerView.bounds.size;
    TRSeekDirection direction = (location.x > size.width / 2.0) ? TRSeekDirectionForward : TRSeekDirectionBackward;

    if (_accumulatedSeconds > 0 && direction == _lastDirection) {
        _accumulatedSeconds += step;
    } else {
        _accumulatedSeconds = step;
    }
    _lastDirection = direction;

    [_resetTimer invalidate];
    [_resetTimer release];
    _resetTimer = [[NSTimer scheduledTimerWithTimeInterval:kTRSeekAccumulationWindow
                                                     target:self
                                                   selector:@selector(resetAccumulator)
                                                   userInfo:nil
                                                    repeats:NO] retain];

    id controller = TRPlayerControllerForPlayerView(_playerView);
    if (!controller) {
        controller = TRActivePlayerController();
    }
    int delta = (direction == TRSeekDirectionForward) ? step : -step;
    if (!TRSeekPlaybackBy(controller, _playerView, delta)) {
        NSLog(@"[TubeFixLegacy] double tap: no player to seek (controller %@)", controller);
        return;
    }

    
    CGFloat centerX = (direction == TRSeekDirectionForward) ? size.width * 0.75 : size.width * 0.25;
    _indicator.center = CGPointMake(roundf(centerX), roundf(size.height / 2.0));
    [_playerView bringSubviewToFront:_indicator];
    [_indicator flashWithDirection:direction totalSeconds:_accumulatedSeconds];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    for (UIView *view = touch.view; view && view != _playerView; view = view.superview) {
        if ([view isKindOfClass:[UIControl class]]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}


- (void)dealloc {
    [_resetTimer invalidate];
    [_resetTimer release];
    [_recognizer removeTarget:self action:NULL];
    _recognizer.delegate = nil;
    [_recognizer release];
    [_indicator release];
    [super dealloc];
}

@end

static void TRAttachDoubleTapSeek(UIView *playerView) {
    TRDoubleTapSeekHandler *handler = objc_getAssociatedObject(playerView, kTRDoubleTapHandlerKey);
    if (!handler) {
        handler = [[TRDoubleTapSeekHandler alloc] initWithPlayerView:playerView];
        TFLLog(@"double tap: attached to %@ %@", NSStringFromClass([playerView class]), NSStringFromCGRect(playerView.bounds));
        objc_setAssociatedObject(playerView, kTRDoubleTapHandlerKey, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [handler release];
    }
    
    [handler attachToSingleTapRecognizers];
}


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

@class YTPlayerView; 
static void (*_logos_orig$_ungrouped$YTPlayerView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTPlayerView$setOverlayView$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL, UIView *); static void _logos_method$_ungrouped$YTPlayerView$setOverlayView$(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL, UIView *); 

#line 195 "googleapp/doubletapseek.x"



static void _logos_method$_ungrouped$YTPlayerView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerView$layoutSubviews(self, _cmd);
    TRAttachDoubleTapSeek((UIView *)self);
}



static void _logos_method$_ungrouped$YTPlayerView$setOverlayView$(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIView * overlayView) {
    _logos_orig$_ungrouped$YTPlayerView$setOverlayView$(self, _cmd, overlayView);
    TRAttachDoubleTapSeek((UIView *)self);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTPlayerView = objc_getClass("YTPlayerView"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$YTPlayerView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$YTPlayerView$layoutSubviews);}{ MSHookMessageEx(_logos_class$_ungrouped$YTPlayerView, @selector(setOverlayView:), (IMP)&_logos_method$_ungrouped$YTPlayerView$setOverlayView$, (IMP*)&_logos_orig$_ungrouped$YTPlayerView$setOverlayView$);}} }
#line 211 "googleapp/doubletapseek.x"
