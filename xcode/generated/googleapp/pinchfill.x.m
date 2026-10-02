#line 1 "googleapp/pinchfill.x"












#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "general.h"

static const void *kTRPinchFillHandlerKey = &kTRPinchFillHandlerKey;

static void TRCollectVideoLayers(CALayer *layer, NSMutableArray *layers, int depth) {
    if (!layer || depth > 12) {
        return;
    }
    if ([layer isKindOfClass:[AVPlayerLayer class]]) {
        [layers addObject:layer];
    }
    for (CALayer *sublayer in [layer sublayers]) {
        TRCollectVideoLayers(sublayer, layers, depth + 1);
    }
}



static BOOL TRViewIsFullScreen(UIView *view) {
    UIWindow *window = view.window;
    if (!window) {
        return NO;
    }
    CGRect frame = [view convertRect:view.bounds toView:nil];
    CGSize windowSize = window.bounds.size;
    return frame.size.width * frame.size.height >= 0.85 * windowSize.width * windowSize.height;
}

@interface TRPinchFillHandler : NSObject <UIGestureRecognizerDelegate>
{
    UIView *_playerView; 
    UIPinchGestureRecognizer *_recognizer;
    UILabel *_hint;
    BOOL _filled;
    BOOL _startedFullScreen;
    NSString *_originalGravity;
}
- (id)initWithPlayerView:(UIView *)playerView;
- (void)playerViewDidLayout;
@end

@implementation TRPinchFillHandler


- (id)initWithPlayerView:(UIView *)playerView {
    self = [super init];
    if (self) {
        _playerView = playerView;
        _recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
        _recognizer.delegate = self;
        _recognizer.cancelsTouchesInView = NO;
        _recognizer.delaysTouchesEnded = NO;
        [playerView addGestureRecognizer:_recognizer];
    }
    return self;
}


- (void)applyGravityAnimated:(BOOL)animated {
    NSMutableArray *layers = [NSMutableArray array];
    TRCollectVideoLayers(_playerView.layer, layers, 0);
    [CATransaction begin];
    [CATransaction setAnimationDuration:animated ? 0.25 : 0];
    [CATransaction setDisableActions:!animated];
    for (AVPlayerLayer *layer in layers) {
        if (_filled) {
            if (!_originalGravity && ![layer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                _originalGravity = [layer.videoGravity copy];
            }
            if (![layer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            }
        } else {
            NSString *gravity = _originalGravity ?: AVLayerVideoGravityResizeAspect;
            if (![layer.videoGravity isEqualToString:gravity]) {
                layer.videoGravity = gravity;
            }
        }
    }
    [CATransaction commit];
}


- (void)showHint:(NSString *)text {
    if (!_hint) {
        _hint = [[UILabel alloc] initWithFrame:CGRectZero];
        _hint.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _hint.textColor = [UIColor whiteColor];
        _hint.font = [UIFont boldSystemFontOfSize:14];
        _hint.textAlignment = NSTextAlignmentCenter;
        _hint.layer.cornerRadius = 6;
        _hint.layer.masksToBounds = YES;
        _hint.userInteractionEnabled = NO;
    }
    _hint.text = text;
    CGSize size = [text sizeWithFont:_hint.font];
    CGRect bounds = _playerView.bounds;
    _hint.frame = CGRectMake(roundf((bounds.size.width - size.width - 24) / 2), 24, size.width + 24, 30);
    [_playerView addSubview:_hint];
    [_playerView bringSubviewToFront:_hint];
    _hint.alpha = 1;
    [UIView animateWithDuration:0.4 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _hint.alpha = 0;
    } completion:nil];
}


- (void)didPinch:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startedFullScreen = TRViewIsFullScreen(_playerView);
        return;
    }
    if (recognizer.state != UIGestureRecognizerStateEnded || !TRPinchToFillEnabled()) {
        return;
    }
    if (recognizer.scale > 1.12 && _startedFullScreen && !_filled) {
        _filled = YES;
        [self applyGravityAnimated:YES];
        [self showHint:TRLocalized(@"Zoomed to fill", @"Во весь экран")];
        TFLLog(@"pinch: zoomed to fill");
    } else if (recognizer.scale < 0.9 && _filled) {
        _filled = NO;
        [self applyGravityAnimated:YES];
        [self showHint:TRLocalized(@"Original", @"Исходный размер")];
        TFLLog(@"pinch: back to the whole picture");
    }
}




- (void)playerViewDidLayout {
    if (!_filled) {
        return;
    }
    if (!TRViewIsFullScreen(_playerView) || !TRPinchToFillEnabled()) {
        _filled = NO;
    }
    [self applyGravityAnimated:NO];
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
    
    return YES;
}


- (void)dealloc {
    [_recognizer removeTarget:self action:NULL];
    _recognizer.delegate = nil;
    [_recognizer release];
    [_hint removeFromSuperview];
    [_hint release];
    [_originalGravity release];
    [super dealloc];
}

@end

static void TRAttachPinchFill(UIView *playerView) {
    TRPinchFillHandler *handler = objc_getAssociatedObject(playerView, kTRPinchFillHandlerKey);
    if (!handler) {
        handler = [[TRPinchFillHandler alloc] initWithPlayerView:playerView];
        objc_setAssociatedObject(playerView, kTRPinchFillHandlerKey, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [handler release];
    }
    [handler playerViewDidLayout];
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
static void (*_logos_orig$_ungrouped$YTPlayerView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$YTPlayerView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST, SEL); 

#line 199 "googleapp/pinchfill.x"



static void _logos_method$_ungrouped$YTPlayerView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL YTPlayerView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$YTPlayerView$layoutSubviews(self, _cmd);
    TRAttachPinchFill((UIView *)self);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTPlayerView = objc_getClass("YTPlayerView"); { MSHookMessageEx(_logos_class$_ungrouped$YTPlayerView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$YTPlayerView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$YTPlayerView$layoutSubviews);}} }
#line 208 "googleapp/pinchfill.x"
