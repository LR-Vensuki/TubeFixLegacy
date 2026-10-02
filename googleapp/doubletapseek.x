// doubletapseek.x
// TubeFixLegacy
//
// Double-tap the left/right half of the player to seek back/forward
// (10 s by default, see DoubleTapSeekSeconds), the same gesture as current
// YouTube. Rapid repeated double-taps on the same side accumulate (10 s,
// then 20 s, ...), resetting once the person stops tapping for a bit or
// switches sides.
//
// Where the player's own single tap ("show/hide controls") lives, checked
// against the app binaries:
//   1.0.x - 1.4.0  YTPlayerView.tapRecognizer_ / _tapRecognizer, on the
//                  YTPlayerView itself
//   2.x            YTPlayerOverlayViewController._tapRecognizer, on the
//                  overlay view - a *subview* of YTPlayerView
// The old build only looked at YTPlayerView's own recognizers, so on 2.x
// the overlay's single tap fired on the first tap and made our double tap
// fail every time. Now every single-tap recognizer in the player view's
// subtree is made to wait for the double tap.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "general.h"
#import "TRPlayback.h"
#import "TRSeekIndicatorView.h"

// a second double-tap after this long starts a fresh accumulation
static const NSTimeInterval kTRSeekAccumulationWindow = 1.5;

static const void *kTRDoubleTapHandlerKey = &kTRDoubleTapHandlerKey;

@interface TRDoubleTapSeekHandler : NSObject <UIGestureRecognizerDelegate>
{
    UIView *_playerView; // not retained, it owns us
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

- (id)initWithPlayerView:(UIView *)playerView
{
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
        // buttons and sliders keep their own behaviour
        if (![subview isKindOfClass:[UIControl class]]) {
            TRCollectSingleTapRecognizers(subview, recognizers, depth + 1);
        }
    }
}

// the player's own show/hide-controls tap must wait until we know it
// wasn't the first half of a double tap
- (void)attachToSingleTapRecognizers
{
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

- (void)resetAccumulator
{
    _accumulatedSeconds = 0;
    [_resetTimer release];
    _resetTimer = nil;
}

- (void)didDoubleTap:(UITapGestureRecognizer *)recognizer
{
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

    // centred in the half that was tapped, above whatever the app added since
    CGFloat centerX = (direction == TRSeekDirectionForward) ? size.width * 0.75 : size.width * 0.25;
    _indicator.center = CGPointMake(roundf(centerX), roundf(size.height / 2.0));
    [_playerView bringSubviewToFront:_indicator];
    [_indicator flashWithDirection:direction totalSeconds:_accumulatedSeconds];
}

// don't eat double taps on the play button, scrubber, etc.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    for (UIView *view = touch.view; view && view != _playerView; view = view.superview) {
        if ([view isKindOfClass:[UIControl class]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // coexist with the view's pinch-to-fullscreen, never with other taps
    return ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (void)dealloc
{
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
    // cheap, and catches recognizers the app adds after we first ran
    [handler attachToSingleTapRecognizers];
}

%hook YTPlayerView

- (void)layoutSubviews
{
    %orig;
    TRAttachDoubleTapSeek((UIView *)self);
}

// 2.x: the overlay (with the controls' tap recognizer) is swapped in here
- (void)setOverlayView:(UIView *)overlayView
{
    %orig;
    TRAttachDoubleTapSeek((UIView *)self);
}

%end
