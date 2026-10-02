// pinchfill.x
// TubeFixLegacy
//
// Pinch to fill, as in current YouTube: on a full-screen video, spreading
// two fingers crops the picture to fill the whole screen (no black bars),
// pinching back shows all of it again. Leaving full screen goes back to
// the whole picture.
//
// The app's own pinch on YTPlayerView (pinch out = full screen) keeps
// working - ours only recognises alongside it, and only counts as "fill"
// when the player was already full screen when the pinch began.

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

// covers (almost) the whole window - works in either orientation, since
// it only compares areas
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
    UIView *_playerView; // not retained, it owns us
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

- (id)initWithPlayerView:(UIView *)playerView
{
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

- (void)applyGravityAnimated:(BOOL)animated
{
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

- (void)showHint:(NSString *)text
{
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

- (void)didPinch:(UIPinchGestureRecognizer *)recognizer
{
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

// keeps the crop on a new video / re-created layer, and drops it when the
// player leaves full screen
- (void)playerViewDidLayout
{
    if (!_filled) {
        return;
    }
    if (!TRViewIsFullScreen(_playerView) || !TRPinchToFillEnabled()) {
        _filled = NO;
    }
    [self applyGravityAnimated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // not on the scrubber, buttons, etc.
    for (UIView *view = touch.view; view && view != _playerView; view = view.superview) {
        if ([view isKindOfClass:[UIControl class]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // alongside the app's pinch-to-full-screen and everything else
    return YES;
}

- (void)dealloc
{
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

%hook YTPlayerView

- (void)layoutSubviews
{
    %orig;
    TRAttachPinchFill((UIView *)self);
}

%end
