// TRSeekIndicatorView.m
// TubeFixLegacy

#import "TRSeekIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@interface TRSeekIndicatorView ()
{
    UILabel *_label;
    UIView *_glyphContainer;
    TRSeekDirection _direction;
    NSTimer *_hideTimer;
}
@end

@implementation TRSeekIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
        self.layer.cornerRadius = 6.0; // old app uses small, not fully-rounded corners (see YTToastView), not the big pill radius of modern YouTube
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;

        _glyphContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 8, frame.size.width, 28)];
        _glyphContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_glyphContainer];

        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, frame.size.width, 16)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:12.0]; // matches YTToastView's plain system-bold label, not a custom webfont
        [self addSubview:_label];
    }
    return self;
}

// Three stacked chevrons, flat-filled, no gradient/stroke - same
// visual weight as the existing skip/replay glyphs in this app era.
// Drawn in code instead of pulled from an asset catalog, since we
// don't have the original .app bundle to extract a matching glyph from.
- (void)drawChevronsInView:(UIView *)container pointingRight:(BOOL)pointingRight
{
    for (CALayer *sub in [[container.layer.sublayers copy] autorelease]) {
        [sub removeFromSuperlayer];
    }

    CGFloat chevronWidth = 10.0;
    CGFloat chevronHeight = 16.0;
    CGFloat spacing = 6.0;
    CGFloat totalWidth = (chevronWidth * 3) + (spacing * 2);
    CGFloat startX = (container.bounds.size.width - totalWidth) / 2.0;

    for (int i = 0; i < 3; i++) {
        CGFloat x = startX + (i * (chevronWidth + spacing));

        CAShapeLayer *chevron = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (pointingRight) {
            [path moveToPoint:CGPointMake(x, 0)];
            [path addLineToPoint:CGPointMake(x + chevronWidth, chevronHeight / 2.0)];
            [path addLineToPoint:CGPointMake(x, chevronHeight)];
        } else {
            [path moveToPoint:CGPointMake(x + chevronWidth, 0)];
            [path addLineToPoint:CGPointMake(x, chevronHeight / 2.0)];
            [path addLineToPoint:CGPointMake(x + chevronWidth, chevronHeight)];
        }
        [path closePath];

        chevron.path = path.CGPath;
        chevron.fillColor = [UIColor whiteColor].CGColor;
        chevron.frame = container.bounds;
        [container.layer addSublayer:chevron];
    }
}

- (void)flashWithDirection:(TRSeekDirection)direction totalSeconds:(int)seconds
{
    _direction = direction;
    [self drawChevronsInView:_glyphContainer pointingRight:(direction == TRSeekDirectionForward)];
    _label.text = [NSString stringWithFormat:@"%d %@", seconds,
                    (seconds == 1)
                        ? NSLocalizedString(@"second", nil)
                        : NSLocalizedString(@"seconds", nil)];

    // the timer is retained here: once a non-repeating timer fires the run
    // loop lets go of it, and invalidating that stale pointer on the next
    // double tap used to crash
    [_hideTimer invalidate];
    [_hideTimer release];

    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.0;
    }];

    _hideTimer = [[NSTimer scheduledTimerWithTimeInterval:0.6
                                                    target:self
                                                  selector:@selector(hide)
                                                  userInfo:nil
                                                   repeats:NO] retain];
}

- (void)hide
{
    [_hideTimer release];
    _hideTimer = nil;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)dealloc
{
    [_hideTimer invalidate];
    [_hideTimer release];
    [_label release];
    [_glyphContainer release];
    [super dealloc];
}

@end
