// TRSeekIndicatorView.h
// TubeFixLegacy
//
// A small overlay shown briefly over the player when the person
// double-taps to seek, styled to match the flat, single-color glyph
// language already used by YTPlayerControlsView in 1.0-1.4 (plain
// white glyph, no gradients/shadows) rather than the modern circular
// "+10 / -10 with a spinning arc" indicator from current YouTube.

#import <UIKit/UIKit.h>

typedef enum {
    TRSeekDirectionBackward = 0,
    TRSeekDirectionForward = 1
} TRSeekDirection;

@interface TRSeekIndicatorView : UIView

// Shows (or updates, if already visible on the same side) the
// indicator for `seconds` accumulated seek amount, then fades out
// automatically after a short delay. Safe to call repeatedly for
// rapid multi-taps (e.g. double-tap-double-tap to seek 20s) - it
// resets its own hide timer each call instead of stacking views.
- (void)flashWithDirection:(TRSeekDirection)direction totalSeconds:(int)seconds;

@end
