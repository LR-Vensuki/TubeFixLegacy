// TRShortsPlayer.m
// TubeFixLegacy
//
// See TRShortsPlayer.h. Built for iOS 5/6 (manual retain/release, no Auto
// Layout, no blocks-based KVO), so everything is laid out by hand.
//
// Pieces:
//   TRSPItem        one Short: what the feed said about it, then the
//                   YTVideo + stream candidates from /player
//   TRSPPageView    one screen: thumbnail, AVPlayerLayer, captions, the
//                   like/dislike/share/open buttons on the right
//   TRSPViewController
//                   a vertically paging scroll view with three recycled
//                   pages (previous, current, next); plays the current
//                   one, preloads the next, fetches more Shorts near the
//                   end of the list

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TRShortsPlayer.h"
#import "TRShorts.h"
#import "TRPlayback.h"
#import "TRPlayerRequest.h"
#import "general.h"
#import "Translators/TRTranslators.h"
#import "common/SABR/TRSabrStream.h"
#import "../base64/NSData+Base64.h"

// Everything below is messaged as a bare id; this gives the compiler the
// right signatures.
@protocol TRSPMessages
- (NSArray *)streams;
- (int)format;
- (NSURL *)URL;
- (unsigned long long)likesCount;
- (BOOL)isStreamBad;
- (BOOL)authorizeNSRequest:(NSMutableURLRequest **)request;
@end

#pragma mark - Text

// "Language" in TubeFixLegacy's settings (auto follows iOS)
static BOOL TRSPRussian(void) {
    return TRTweakLanguageIsRussian();
}

#define TRSPText(english, russian) (TRSPRussian() ? (russian) : (english))

// 1234 -> "1.2K" / "1,2 тыс."
static NSString *TRSPCount(long long count) {
    if (count < 0) {
        return nil;
    }
    if (count < 1000) {
        return [NSString stringWithFormat:@"%lld", count];
    }
    double value;
    NSString *suffix;
    if (count < 1000000LL) {
        value = count / 1e3;
        suffix = TRSPText(@"K", @" тыс.");
    } else if (count < 1000000000LL) {
        value = count / 1e6;
        suffix = TRSPText(@"M", @" млн");
    } else {
        value = count / 1e9;
        suffix = TRSPText(@"B", @" млрд");
    }
    NSString *number = value < 10 ? [NSString stringWithFormat:@"%.1f", floor(value * 10) / 10] : [NSString stringWithFormat:@"%.0f", floor(value)];
    if ([number hasSuffix:@".0"]) {
        number = [number substringToIndex:[number length] - 2];
    }
    if (TRSPRussian()) {
        number = [number stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    return [number stringByAppendingString:suffix];
}

static NSString *TRSPViewsText(NSNumber *views) {
    long long count = [views longLongValue];
    if (count <= 0) {
        return nil;
    }
    if (TRSPRussian()) {
        NSString *word = @"просмотров";
        if (count < 1000) {
            long long lastDigit = count % 10, lastTwo = count % 100;
            if (lastDigit == 1 && lastTwo != 11) {
                word = @"просмотр";
            } else if (lastDigit >= 2 && lastDigit <= 4 && (lastTwo < 12 || lastTwo > 14)) {
                word = @"просмотра";
            }
        }
        return [NSString stringWithFormat:@"%@ %@", TRSPCount(count), word];
    }
    return [NSString stringWithFormat:@"%@ %@", TRSPCount(count), count == 1 ? @"view" : @"views"];
}

#pragma mark - Icons

// Material Design icons (Apache License 2.0), 24x24 SVG paths, drawn at
// runtime so the tweak doesn't need image files for them.
static const char *kTRSPThumbUpPath = "M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z";
static const char *kTRSPThumbDownPath = "M15 3H6c-.83 0-1.54.5-1.84 1.22l-3.02 7.05c-.09.23-.14.47-.14.73v2c0 1.1.9 2 2 2h6.31l-.95 4.57-.03.32c0 .41.17.79.44 1.06L9.83 23l6.59-6.59c.36-.36.58-.86.58-1.41V5c0-1.1-.9-2-2-2zm4 0v12h4V3h-4z";
static const char *kTRSPSharePath = "M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92 1.61 0 2.92-1.31 2.92-2.92s-1.31-2.92-2.92-2.92z";
static const char *kTRSPClosePath = "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z";
static const char *kTRSPPlayPath = "M8 5v14l11-7z";
static const char *kTRSPOpenPath = "M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z";

static CGFloat TRSPNumber(const char **cursor) {
    const char *s = *cursor;
    while (*s == ' ' || *s == ',' || *s == '\n' || *s == '\t') s++;
    char *end = NULL;
    double value = strtod(s, &end);
    *cursor = (end && end != s) ? end : (*s ? s + 1 : s);
    return (CGFloat)value;
}

// Enough of SVG path syntax for the icons above: M L H V C S Z, absolute
// and relative, with implicit repetition.
static CGPathRef TRSPCreatePath(const char *d) {
    CGMutablePathRef path = CGPathCreateMutable();
    const char *s = d;
    char command = 0;
    CGFloat x = 0, y = 0, startX = 0, startY = 0, controlX = 0, controlY = 0;
    BOOL lastWasCurve = NO;
    while (*s) {
        while (*s == ' ' || *s == ',' || *s == '\n' || *s == '\t') s++;
        if (!*s) {
            break;
        }
        if (isalpha((unsigned char)*s)) {
            command = *s++;
            if (command == 'z' || command == 'Z') {
                CGPathCloseSubpath(path);
                x = startX;
                y = startY;
                lastWasCurve = NO;
            }
            continue;
        }
        BOOL relative = islower((unsigned char)command) != 0;
        CGFloat originX = relative ? x : 0, originY = relative ? y : 0;
        switch (toupper((unsigned char)command)) {
            case 'M': {
                x = startX = originX + TRSPNumber(&s);
                y = startY = originY + TRSPNumber(&s);
                CGPathMoveToPoint(path, NULL, x, y);
                command = relative ? 'l' : 'L';
                lastWasCurve = NO;
                break;
            }
            case 'L': {
                x = originX + TRSPNumber(&s);
                y = originY + TRSPNumber(&s);
                CGPathAddLineToPoint(path, NULL, x, y);
                lastWasCurve = NO;
                break;
            }
            case 'H': {
                x = originX + TRSPNumber(&s);
                CGPathAddLineToPoint(path, NULL, x, y);
                lastWasCurve = NO;
                break;
            }
            case 'V': {
                y = originY + TRSPNumber(&s);
                CGPathAddLineToPoint(path, NULL, x, y);
                lastWasCurve = NO;
                break;
            }
            case 'C': {
                CGFloat c1x = originX + TRSPNumber(&s), c1y = originY + TRSPNumber(&s);
                CGFloat c2x = originX + TRSPNumber(&s), c2y = originY + TRSPNumber(&s);
                CGFloat ex = originX + TRSPNumber(&s), ey = originY + TRSPNumber(&s);
                CGPathAddCurveToPoint(path, NULL, c1x, c1y, c2x, c2y, ex, ey);
                controlX = c2x;
                controlY = c2y;
                x = ex;
                y = ey;
                lastWasCurve = YES;
                break;
            }
            case 'S': {
                CGFloat c1x = lastWasCurve ? 2 * x - controlX : x;
                CGFloat c1y = lastWasCurve ? 2 * y - controlY : y;
                CGFloat c2x = originX + TRSPNumber(&s), c2y = originY + TRSPNumber(&s);
                CGFloat ex = originX + TRSPNumber(&s), ey = originY + TRSPNumber(&s);
                CGPathAddCurveToPoint(path, NULL, c1x, c1y, c2x, c2y, ex, ey);
                controlX = c2x;
                controlY = c2y;
                x = ex;
                y = ey;
                lastWasCurve = YES;
                break;
            }
            default:
                s++;
                break;
        }
    }
    return path;
}

static UIImage *TRSPIcon(const char *svgPath, CGFloat size, UIColor *color) {
    CGFloat padding = 3;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size + padding * 2, size + padding * 2), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 2.5, [[UIColor colorWithWhite:0 alpha:0.55] CGColor]);
    CGContextTranslateCTM(context, padding, padding);
    CGContextScaleCTM(context, size / 24.0, size / 24.0);
    CGPathRef path = TRSPCreatePath(svgPath);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextEOFillPath(context);
    CGPathRelease(path);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static UIColor *TRSPAccentColor(void) {
    return [UIColor colorWithRed:0.24 green:0.65 blue:1.0 alpha:1.0];
}

// the rail icons get redrawn on every state change otherwise
static UIImage *TRSPRatingIcon(BOOL dislike, BOOL active) {
    static UIImage *icons[4];
    int slot = (dislike ? 2 : 0) + (active ? 1 : 0);
    if (!icons[slot]) {
        icons[slot] = [TRSPIcon(dislike ? kTRSPThumbDownPath : kTRSPThumbUpPath, 30, active ? TRSPAccentColor() : [UIColor whiteColor]) retain];
    }
    return icons[slot];
}

#pragma mark - Network

static NSData *TRSPStripXSSIPrefix(NSData *data) {
    const unsigned char *bytes = [data bytes];
    if ([data length] >= 5 && bytes[0] == ')' && bytes[1] == ']' && bytes[2] == '}' && bytes[3] == '\'' && bytes[4] == '\n') {
        return [data subdataWithRange:NSMakeRange(5, [data length] - 5)];
    }
    return data;
}

typedef enum {
    TRSPAuthNone = 0,
    TRSPAuthRequired,     // fails without a signed-in account
    TRSPAuthIfSignedIn    // personalised when someone is signed in
} TRSPAuthMode;

// Synchronous - only ever called off the main thread. body nil = GET.
static id TRSPFetchJSON(NSURL *url, NSData *body, TRSPAuthMode authMode, NSString **errorOut) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    if (body) {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
    }
    if (authMode != TRSPAuthNone) {
        id auth = TRCurrentSignedInAuth();
        BOOL authorized = auth && [auth respondsToSelector:@selector(authorizeNSRequest:)] && [(id<TRSPMessages>)auth authorizeNSRequest:&request];
        if (!authorized && authMode == TRSPAuthRequired) {
            if (errorOut) *errorOut = TRSPText(@"Sign in to YouTube to rate videos.", @"Войдите в YouTube, чтобы оценивать видео.");
            return nil;
        }
    }
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        if (errorOut) *errorOut = [error localizedDescription] ?: TRSPText(@"Network error", @"Ошибка сети");
        return nil;
    }
    id json = [NSJSONSerialization JSONObjectWithData:TRSPStripXSSIPrefix(data) options:0 error:NULL];
    if ([response statusCode] >= 400) {
        if (errorOut) *errorOut = [NSString stringWithFormat:TRSPText(@"Server error %d", @"Ошибка сервера %d"), (int)[response statusCode]];
        TFLLog(@"Shorts: %@ -> HTTP %d %@", url, (int)[response statusCode], json);
        return nil;
    }
    if (!json && errorOut) {
        *errorOut = TRSPText(@"Unexpected response", @"Непонятный ответ сервера");
    }
    return json;
}

// The real Shorts feed: /reel/reel_watch_sequence returns what the Shorts
// player on youtube.com would play after a given Short (about 20 per
// call, with a continuation). sequenceParams for the first call is a tiny
// protobuf naming the seed video; later calls pass the continuation token.
static NSString *TRSPSequenceParamsForVideo(NSString *videoID) {
    NSData *idData = [videoID dataUsingEncoding:NSUTF8StringEncoding];
    if ([idData length] == 0 || [idData length] > 127) {
        return nil;
    }
    NSMutableData *data = [NSMutableData data];
    uint8_t header[2] = { 0x0a, (uint8_t)[idData length] };     // 1: video ID
    [data appendBytes:header length:2];
    [data appendData:idData];
    uint8_t tail[8] = { 0x2a, 0x02, 0x18, 0x01, 0x50, 0x19, 0x68, 0x00 };
    [data appendBytes:tail length:8];
    return [data base64EncodedString];
}

static void TRSPCollectSequence(NSDictionary *json, NSMutableArray *shorts, NSString **continuation) {
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *entries = [json objectForKey:@"entries"];
    if ([entries isKindOfClass:[NSArray class]]) {
        for (NSDictionary *entry in entries) {
            if (![entry isKindOfClass:[NSDictionary class]]) continue;
            NSDictionary *endpoint = [TRJSONUtils dictFromJSON:entry keyPath:@"command.reelWatchEndpoint"];
            NSString *videoID = [endpoint objectForKey:@"videoId"];
            if (![videoID isKindOfClass:[NSString class]] || [videoID length] == 0) continue;
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObject:videoID forKey:TR_SHORT_VIDEO_ID];
            NSString *thumbnail = [TRJSONUtils stringFromJSON:endpoint keyPath:@"thumbnail.thumbnails[0].url"];
            NSURL *thumbnailURL = [thumbnail isKindOfClass:[NSString class]] ? [NSURL URLWithString:thumbnail] : nil;
            [info setObject:(thumbnailURL ?: [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/hqdefault.jpg", videoID]]) forKey:TR_SHORT_THUMBNAIL];
            [shorts addObject:info];
        }
    }
    NSString *token = [TRJSONUtils stringFromJSON:json keyPath:@"continuationEndpoint.continuationCommand.token"];
    if (continuation && [token isKindOfClass:[NSString class]]) {
        *continuation = token;
    }
}

// Portrait Shorts thumbnails are 1080x1920 - decoded that's 8 MB each, too
// much for an iPhone 4 keeping a few around. Scale to the screen.
static UIImage *TRSPScaledThumbnail(NSData *data) {
    UIImage *image = data ? [UIImage imageWithData:data] : nil;
    if (!image) {
        return nil;
    }
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screen = [UIScreen mainScreen].bounds.size;
    CGFloat maxSide = MAX(screen.width, screen.height) * screenScale;
    CGSize size = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    CGFloat longest = MAX(size.width, size.height);
    if (longest <= maxSide) {
        return image;
    }
    CGFloat factor = maxSide / longest;
    CGSize target = CGSizeMake(floor(size.width * factor / screenScale), floor(size.height * factor / screenScale));
    UIGraphicsBeginImageContextWithOptions(target, YES, screenScale);
    [image drawInRect:CGRectMake(0, 0, target.width, target.height)];
    UIImage *scaled = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled ?: image;
}

#pragma mark - TRSPItem

enum {
    TRSPItemIdle = 0,
    TRSPItemLoading,
    TRSPItemReady,
    TRSPItemFailed
};

@interface TRSPItem : NSObject
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) id video;
@property (nonatomic, retain) NSArray *streams;      // best first
@property (nonatomic, assign) NSUInteger streamIndex;
@property (nonatomic, retain) TRSabrStream *startedSabrStream;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) long long likes;
@property (nonatomic, assign) long long dislikes;
@property (nonatomic, assign) TRLikeState likeState;
@property (nonatomic, assign) BOOL ratingInFlight;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, assign) BOOL thumbnailRequested;
@property (nonatomic, assign) NSUInteger generation;
- (id)initWithInfo:(NSDictionary *)info;
- (NSString *)videoID;
- (id)currentStream;
- (void)stopStreams;
- (void)reset;
@end

@implementation TRSPItem

- (id)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        _info = [info retain];
        _likes = -1;
        _dislikes = -1;
        _likeState = TRGetCachedLikeState([self videoID]);
    }
    return self;
}

- (NSString *)videoID {
    return [_info objectForKey:TR_SHORT_VIDEO_ID];
}

- (id)currentStream {
    return _streamIndex < [_streams count] ? [_streams objectAtIndex:_streamIndex] : nil;
}

- (void)stopStreams {
    if (_startedSabrStream) {
        TRSabrStream *stream = _startedSabrStream;
        // declareStreamBad calls this unconditionally - never leave it nil
        stream.reloadPlayerFunction = ^{};
        [stream cleanup];
        [stream release];
        _startedSabrStream = nil;
    }
}

- (void)reset {
    [self stopStreams];
    self.video = nil;
    self.streams = nil;
    self.streamIndex = 0;
    self.errorMessage = nil;
    self.state = TRSPItemIdle;
    self.generation = self.generation + 1;
}

- (void)dealloc {
    [self stopStreams];
    [_info release];
    [_video release];
    [_streams release];
    [_errorMessage release];
    [_thumbnail release];
    [super dealloc];
}

@end

#pragma mark - Page

@class TRSPPageView;

@interface TRSPViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>
- (id)initWithSequence:(NSArray *)sequence startIndex:(NSUInteger)index openInRegularPlayer:(void (^)(NSString *))openInRegularPlayer;
- (BOOL)isCurrentPageIndex:(NSInteger)index;
- (void)pagePlayerFailed:(TRSPPageView *)page;
- (void)pageWantsRetry:(TRSPPageView *)page;
- (void)pageWantsLike:(TRSPPageView *)page dislike:(BOOL)dislike;
- (void)pageWantsShare:(TRSPPageView *)page;
- (void)pageWantsRegularPlayer:(TRSPPageView *)page;
- (void)sabrStreamNeedsReloadForItem:(TRSPItem *)item;
- (BOOL)canOpenRegularPlayer;
@end

@interface TRSPPageView : UIView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) TRSPItem *item;
@property (nonatomic, assign) TRSPViewController *controller;
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, assign) BOOL waitingForSabrPort;
@property (nonatomic, assign) CFAbsoluteTime sabrWaitStarted;
- (void)showItem:(TRSPItem *)item index:(NSInteger)index;
- (void)refresh;
- (void)attachPlayerWithURL:(NSURL *)url;
- (void)teardownPlayer;
- (void)play;
- (void)pause;
- (BOOL)isPlaying;
- (void)restart;
- (double)currentTime;
- (double)duration;
- (void)flashPlayIcon:(BOOL)paused;
- (void)flashLike;
@end

@implementation TRSPPageView {
    UIImageView *_thumbnailView;
    UIView *_videoView;
    AVPlayerLayer *_playerLayer;
    CAGradientLayer *_topShade;
    CAGradientLayer *_bottomShade;
    UIActivityIndicatorView *_spinner;
    UIImageView *_centerIcon;
    UILabel *_authorLabel;
    UILabel *_titleLabel;
    UILabel *_viewsLabel;
    UIButton *_likeButton;
    UIButton *_dislikeButton;
    UIButton *_shareButton;
    UIButton *_openButton;
    UILabel *_likeLabel;
    UILabel *_dislikeLabel;
    UILabel *_shareLabel;
    UILabel *_openLabel;
    UIView *_errorView;
    UILabel *_errorLabel;
    UIButton *_retryButton;
    AVPlayerItem *_observedItem;
    BOOL _buffering;
}

static void *kTRSPPlayerItemContext = &kTRSPPlayerItemContext;

- (UILabel *)makeLabelWithFont:(UIFont *)font lines:(NSInteger)lines {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.numberOfLines = lines;
    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
    label.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:label];
    return label;
}

- (UIButton *)makeRailButtonWithIcon:(const char *)icon action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:TRSPIcon(icon, 30, [UIColor whiteColor]) forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (UILabel *)makeRailLabel {
    UILabel *label = [self makeLabelWithFont:[UIFont boldSystemFontOfSize:12] lines:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 9;
    return label;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _index = -1;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;

        _thumbnailView = [[UIImageView alloc] initWithFrame:self.bounds];
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailView.clipsToBounds = YES;
        [self addSubview:_thumbnailView];

        _videoView = [[UIView alloc] initWithFrame:self.bounds];
        _videoView.backgroundColor = [UIColor clearColor];
        _videoView.userInteractionEnabled = NO;
        [self addSubview:_videoView];
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [_videoView.layer addSublayer:_playerLayer];

        _topShade = [[CAGradientLayer alloc] init];
        _topShade.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:0.55] CGColor], (id)[[UIColor colorWithWhite:0 alpha:0] CGColor], nil];
        [self.layer addSublayer:_topShade];
        _bottomShade = [[CAGradientLayer alloc] init];
        _bottomShade.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:0] CGColor], (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor], nil];
        [self.layer addSublayer:_bottomShade];

        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.hidesWhenStopped = YES;
        [self addSubview:_spinner];

        _centerIcon = [[UIImageView alloc] initWithImage:TRSPIcon(kTRSPPlayPath, 64, [UIColor colorWithWhite:1 alpha:0.9])];
        _centerIcon.alpha = 0;
        [self addSubview:_centerIcon];

        _authorLabel = [[self makeLabelWithFont:[UIFont boldSystemFontOfSize:15] lines:1] retain];
        _titleLabel = [[self makeLabelWithFont:[UIFont systemFontOfSize:14] lines:3] retain];
        _viewsLabel = [[self makeLabelWithFont:[UIFont systemFontOfSize:12] lines:1] retain];
        _viewsLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1];

        _likeButton = [[self makeRailButtonWithIcon:kTRSPThumbUpPath action:@selector(likeTapped)] retain];
        _dislikeButton = [[self makeRailButtonWithIcon:kTRSPThumbDownPath action:@selector(dislikeTapped)] retain];
        _shareButton = [[self makeRailButtonWithIcon:kTRSPSharePath action:@selector(shareTapped)] retain];
        _openButton = [[self makeRailButtonWithIcon:kTRSPOpenPath action:@selector(openTapped)] retain];
        _likeLabel = [[self makeRailLabel] retain];
        _dislikeLabel = [[self makeRailLabel] retain];
        _shareLabel = [[self makeRailLabel] retain];
        _openLabel = [[self makeRailLabel] retain];
        _shareLabel.text = TRSPText(@"Share", @"Поделиться");
        _openLabel.text = TRSPText(@"Player", @"Плеер");

        _errorView = [[UIView alloc] initWithFrame:CGRectZero];
        _errorView.hidden = YES;
        [self addSubview:_errorView];
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.textColor = [UIColor whiteColor];
        _errorLabel.font = [UIFont systemFontOfSize:15];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.numberOfLines = 4;
        [_errorView addSubview:_errorLabel];
        _retryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_retryButton setTitle:TRSPText(@"Retry", @"Повторить") forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        _retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _retryButton.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.8] CGColor];
        _retryButton.layer.borderWidth = 1;
        _retryButton.layer.cornerRadius = 4;
        [_retryButton addTarget:self action:@selector(retryTapped) forControlEvents:UIControlEventTouchUpInside];
        [_errorView addSubview:_retryButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat width = bounds.size.width, height = bounds.size.height;
    _thumbnailView.frame = bounds;
    _videoView.frame = bounds;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = _videoView.bounds;
    _topShade.frame = CGRectMake(0, 0, width, 90);
    _bottomShade.frame = CGRectMake(0, height - 280, width, 280);
    [CATransaction commit];

    _spinner.center = CGPointMake(width / 2, height / 2);
    _centerIcon.center = CGPointMake(width / 2, height / 2);

    // right rail, bottom up
    CGFloat railX = width - 62;
    CGFloat y = height - 30;
    UIButton *buttons[4] = { _openButton, _shareButton, _dislikeButton, _likeButton };
    UILabel *labels[4] = { _openLabel, _shareLabel, _dislikeLabel, _likeLabel };
    for (int i = 0; i < 4; i++) {
        labels[i].frame = CGRectMake(railX - 4, y - 16, 64, 16);
        buttons[i].frame = CGRectMake(railX + 2, y - 16 - 48, 52, 48);
        y -= 76;
    }

    CGFloat textWidth = width - 14 - 76;
    CGFloat bottom = height - 26;
    CGSize viewsSize = [_viewsLabel.text length] ? CGSizeMake(textWidth, 16) : CGSizeZero;
    _viewsLabel.frame = CGRectMake(14, bottom - viewsSize.height, textWidth, viewsSize.height);
    bottom -= viewsSize.height + (viewsSize.height > 0 ? 4 : 0);
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(textWidth, 18 * 3) lineBreakMode:NSLineBreakByTruncatingTail];
    _titleLabel.frame = CGRectMake(14, bottom - titleSize.height, textWidth, titleSize.height);
    bottom -= titleSize.height + 6;
    _authorLabel.frame = CGRectMake(14, bottom - 19, textWidth, 19);

    _errorView.frame = CGRectMake(20, height / 2 - 70, width - 40, 140);
    _errorLabel.frame = CGRectMake(0, 0, width - 40, 84);
    _retryButton.frame = CGRectMake((width - 40) / 2 - 60, 96, 120, 36);
}

- (void)setRailLabel:(UILabel *)label count:(long long)count fallback:(NSString *)fallback {
    NSString *text = count >= 0 ? TRSPCount(count) : nil;
    label.text = text ?: fallback;
}

- (void)refresh {
    TRSPItem *item = _item;
    NSDictionary *info = item.info;
    NSString *author = [info objectForKey:TR_SHORT_AUTHOR];
    if ([author length] && ![author hasPrefix:@"@"] && [author rangeOfString:@" "].location == NSNotFound) {
        author = [@"@" stringByAppendingString:author];
    }
    _authorLabel.text = author;
    _titleLabel.text = [info objectForKey:TR_SHORT_TITLE];
    _viewsLabel.text = TRSPViewsText([info objectForKey:TR_SHORT_VIEWS]);

    if (item.thumbnail) {
        _thumbnailView.image = item.thumbnail;
        CGSize size = item.thumbnail.size;
        // hqdefault.jpg is 4:3 with black bars around a vertical video;
        // a real portrait thumbnail can fill the screen
        _thumbnailView.contentMode = size.height > size.width ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
    } else {
        _thumbnailView.image = nil;
    }

    BOOL liked = item.likeState == TRLikeStateLiked;
    BOOL disliked = item.likeState == TRLikeStateDisliked;
    [_likeButton setImage:TRSPRatingIcon(NO, liked) forState:UIControlStateNormal];
    [_dislikeButton setImage:TRSPRatingIcon(YES, disliked) forState:UIControlStateNormal];
    [self setRailLabel:_likeLabel count:item.likes fallback:TRSPText(@"Like", @"Нравится")];
    [self setRailLabel:_dislikeLabel count:item.dislikes fallback:TRSPText(@"Dislike", @"Не нравится")];

    _openButton.hidden = _openLabel.hidden = ![_controller canOpenRegularPlayer];

    BOOL failed = item.state == TRSPItemFailed;
    _errorView.hidden = !failed;
    _errorLabel.text = failed ? (item.errorMessage ?: TRSPText(@"Couldn't play this Short.", @"Не удалось воспроизвести этот шортс.")) : nil;
    BOOL loading = item.state == TRSPItemLoading || (item.state == TRSPItemReady && (!_player || _buffering || _waitingForSabrPort));
    if (loading && !failed) {
        [_spinner startAnimating];
    } else {
        [_spinner stopAnimating];
    }
    [self setNeedsLayout];
}

- (void)showItem:(TRSPItem *)item index:(NSInteger)index {
    if (item != _item) {
        [self teardownPlayer];
        self.item = item;
        _centerIcon.alpha = 0;
    }
    self.index = index;
    [self refresh];
}

#pragma mark Player

- (void)stopObservingItem {
    if (_observedItem) {
        [_observedItem removeObserver:self forKeyPath:@"status" context:kTRSPPlayerItemContext];
        [_observedItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:kTRSPPlayerItemContext];
        [_observedItem removeObserver:self forKeyPath:@"presentationSize" context:kTRSPPlayerItemContext];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_observedItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_observedItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVPlayerItemPlaybackStalledNotification" object:_observedItem];
        [_observedItem release];
        _observedItem = nil;
    }
}

- (void)attachPlayerWithURL:(NSURL *)url {
    [self teardownPlayer];
    if (!url) {
        return;
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.player = player;

    _observedItem = [playerItem retain];
    [playerItem addObserver:self forKeyPath:@"status" options:0 context:kTRSPPlayerItemContext];
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:kTRSPPlayerItemContext];
    [playerItem addObserver:self forKeyPath:@"presentationSize" options:0 context:kTRSPPlayerItemContext];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [center addObserver:self selector:@selector(playerItemFailedToReachEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:playerItem];
    [center addObserver:self selector:@selector(playerItemStalled:) name:@"AVPlayerItemPlaybackStalledNotification" object:playerItem];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.player = player;
    [CATransaction commit];
    _buffering = YES;
    [self refresh];
}

- (void)teardownPlayer {
    [self stopObservingItem];
    if (_player) {
        [_player pause];
        _playerLayer.player = nil;
        self.player = nil;
    }
    _buffering = NO;
    _waitingForSabrPort = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != kTRSPPlayerItemContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    // KVO for AVPlayerItem can arrive on other threads
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object != _observedItem) {
            return;
        }
        AVPlayerItem *playerItem = object;
        if ([keyPath isEqualToString:@"status"]) {
            if (playerItem.status == AVPlayerItemStatusFailed) {
                TFLLog(@"Shorts: player item failed for %@: %@", [_item videoID], playerItem.error);
                [_controller pagePlayerFailed:self];
            } else if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
                if ([_controller isCurrentPageIndex:_index] && ![self isPlaying] && _centerIcon.alpha == 0) {
                    [_player play];
                }
            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            _buffering = !playerItem.playbackLikelyToKeepUp;
            [self refresh];
        } else if ([keyPath isEqualToString:@"presentationSize"]) {
            CGSize size = playerItem.presentationSize;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _playerLayer.videoGravity = (size.height > size.width * 1.15) ? AVLayerVideoGravityResizeAspectFill : AVLayerVideoGravityResizeAspect;
            [CATransaction commit];
        }
    });
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    // Shorts loop
    [_player seekToTime:kCMTimeZero];
    if ([_controller isCurrentPageIndex:_index]) {
        [_player play];
    }
}

- (void)playerItemFailedToReachEnd:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_controller pagePlayerFailed:self];
    });
}

- (void)playerItemStalled:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _buffering = YES;
        [self refresh];
    });
}

- (void)play {
    _centerIcon.alpha = 0;
    if (_player && _observedItem.status != AVPlayerItemStatusFailed) {
        [_player play];
    }
}

- (void)pause {
    [_player pause];
}

- (BOOL)isPlaying {
    return _player && [_player rate] > 0;
}

- (void)restart {
    if (_player) {
        [_player seekToTime:kCMTimeZero];
    }
}

- (double)currentTime {
    double time = _player ? CMTimeGetSeconds([_player currentTime]) : 0;
    return isnan(time) ? 0 : time;
}

- (double)duration {
    double duration = _observedItem ? CMTimeGetSeconds([_observedItem duration]) : 0;
    return (isnan(duration) || isinf(duration)) ? 0 : duration;
}

- (void)flashPlayIcon:(BOOL)paused {
    [UIView animateWithDuration:0.15 animations:^{
        _centerIcon.alpha = paused ? 1 : 0;
    }];
}

- (void)flashLike {
    static UIImage *bigThumb = nil;
    if (!bigThumb) {
        bigThumb = [TRSPIcon(kTRSPThumbUpPath, 84, [UIColor whiteColor]) retain];
    }
    UIImageView *heart = [[UIImageView alloc] initWithImage:bigThumb];
    heart.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    heart.alpha = 0;
    heart.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [self addSubview:heart];
    [UIView animateWithDuration:0.18 animations:^{
        heart.alpha = 1;
        heart.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.25 options:0 animations:^{
            heart.alpha = 0;
            heart.transform = CGAffineTransformMakeScale(1.4, 1.4);
        } completion:^(BOOL done) {
            [heart removeFromSuperview];
        }];
    }];
    [heart release];
}

#pragma mark Buttons

- (void)likeTapped {
    [_controller pageWantsLike:self dislike:NO];
}

- (void)dislikeTapped {
    [_controller pageWantsLike:self dislike:YES];
}

- (void)shareTapped {
    [_controller pageWantsShare:self];
}

- (void)openTapped {
    [_controller pageWantsRegularPlayer:self];
}

- (void)retryTapped {
    [_controller pageWantsRetry:self];
}

- (void)dealloc {
    [self teardownPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_item release];
    [_player release];
    [_thumbnailView release];
    [_videoView release];
    [_playerLayer release];
    [_topShade release];
    [_bottomShade release];
    [_spinner release];
    [_centerIcon release];
    [_authorLabel release];
    [_titleLabel release];
    [_viewsLabel release];
    [_likeButton release];
    [_dislikeButton release];
    [_shareButton release];
    [_openButton release];
    [_likeLabel release];
    [_dislikeLabel release];
    [_shareLabel release];
    [_openLabel release];
    [_errorView release];
    [_errorLabel release];
    [_retryButton release];
    [super dealloc];
}

@end

#pragma mark - Controller

static TRSPViewController *gTRSPVisibleController = nil; // not retained

// SABR calls back from its own threads; those callbacks only message a
// controller that is still in here
static NSMutableSet *gTRSPLiveControllers = nil;

static void TRSPLiveControllers(void) {
    if (!gTRSPLiveControllers) {
        gTRSPLiveControllers = [[NSMutableSet alloc] init];
    }
}

static BOOL TRSPControllerIsAlive(TRSPViewController *controller) {
    return controller && [gTRSPLiveControllers containsObject:[NSValue valueWithPointer:controller]];
}

BOOL TRShortsPlayerIsVisible(void) {
    return gTRSPVisibleController != nil;
}

@implementation TRSPViewController {
    NSMutableArray *_items;
    NSMutableSet *_knownIDs;
    NSMutableArray *_pages;
    UIScrollView *_scrollView;
    NSInteger _currentIndex;
    UIButton *_closeButton;
    UILabel *_headerLabel;
    UIView *_progressTrack;
    UIView *_progressFill;
    NSTimer *_timer;
    BOOL _userPaused;
    BOOL _closed;
    BOOL _loadingMore;
    BOOL _hasMore;
    int _emptyLoads;
    NSString *_continuation;           // Shorts search
    NSString *_sequenceContinuation;   // recommendations
    NSString *_seedVideoID;
    BOOL _sequenceFailed;
    BOOL _statusBarWasHidden;
    BOOL _appeared;
    void (^_openInRegularPlayer)(NSString *);
    NSString *_shareVideoID;
}

- (id)initWithSequence:(NSArray *)sequence startIndex:(NSUInteger)index openInRegularPlayer:(void (^)(NSString *))openInRegularPlayer {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _knownIDs = [[NSMutableSet alloc] init];
        NSDictionary *startInfo = index < [sequence count] ? [sequence objectAtIndex:index] : nil;
        NSString *startID = [startInfo objectForKey:TR_SHORT_VIDEO_ID];
        for (NSDictionary *info in sequence) {
            NSString *videoID = [info objectForKey:TR_SHORT_VIDEO_ID];
            if (![videoID isKindOfClass:[NSString class]] || [_knownIDs containsObject:videoID]) {
                continue;
            }
            [_knownIDs addObject:videoID];
            if ([videoID isEqualToString:startID]) {
                _currentIndex = [_items count];
            }
            TRSPItem *item = [[TRSPItem alloc] initWithInfo:info];
            [_items addObject:item];
            [item release];
        }
        _seedVideoID = [startID copy];
        TRSPLiveControllers();
        [gTRSPLiveControllers addObject:[NSValue valueWithPointer:self]];
        _hasMore = YES;
        _openInRegularPlayer = [openInRegularPlayer copy];
        self.wantsFullScreenLayout = YES;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStateDidChange:) name:TRLikeStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor blackColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
    [view release];

    _scrollView = [[UIScrollView alloc] initWithFrame:view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:_scrollView];

    _pages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        TRSPPageView *page = [[TRSPPageView alloc] initWithFrame:view.bounds];
        page.controller = self;
        [_scrollView addSubview:page];
        [_pages addObject:page];
        [page release];
    }

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [_scrollView addGestureRecognizer:doubleTap];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    singleTap.delegate = self;
    [_scrollView addGestureRecognizer:singleTap];
    [doubleTap release];
    [singleTap release];

    _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_closeButton setImage:TRSPIcon(kTRSPClosePath, 26, [UIColor whiteColor]) forState:UIControlStateNormal];
    [_closeButton setShowsTouchWhenHighlighted:YES];
    [_closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_closeButton];

    _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.font = [UIFont boldSystemFontOfSize:18];
    _headerLabel.text = @"Shorts";
    _headerLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
    _headerLabel.shadowOffset = CGSizeMake(0, 1);
    [view addSubview:_headerLabel];

    _progressTrack = [[UIView alloc] initWithFrame:CGRectZero];
    _progressTrack.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
    _progressTrack.userInteractionEnabled = NO;
    [view addSubview:_progressTrack];
    _progressFill = [[UIView alloc] initWithFrame:CGRectZero];
    _progressFill.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    [_progressTrack addSubview:_progressFill];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutPlayer];
}

- (void)layoutPlayer {
    CGRect bounds = self.view.bounds;
    CGFloat width = bounds.size.width, height = bounds.size.height;
    if (width <= 0 || height <= 0) {
        return;
    }
    _scrollView.frame = bounds;
    _scrollView.contentSize = CGSizeMake(width, height * MAX((NSUInteger)1, [_items count]));
    for (TRSPPageView *page in _pages) {
        if (page.index >= 0) {
            page.frame = CGRectMake(0, height * page.index, width, height);
        }
    }
    CGFloat top = [UIApplication sharedApplication].statusBarHidden ? 0 : 20;
    _closeButton.frame = CGRectMake(4, top + 6, 44, 44);
    _headerLabel.frame = CGRectMake(52, top + 6, 140, 44);
    _progressTrack.frame = CGRectMake(0, height - 3, width, 3);
    [self updateProgress];
    if (!_scrollView.isDragging && !_scrollView.isDecelerating) {
        _scrollView.contentOffset = CGPointMake(0, height * _currentIndex);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _statusBarWasHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self layoutPlayer];
    [self tilePages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_appeared) {
        return;
    }
    _appeared = YES;

    // the app's own player (or mini player) shouldn't keep talking underneath
    id activeController = TRActivePlayerController();
    if (activeController && TRPlaybackIsPlaying(activeController)) {
        TRPlaybackPause(activeController);
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (![[session category] isEqualToString:AVAudioSessionCategoryPlayback]) {
        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    }
    [session setActive:YES error:NULL];
    if (TRLockScreenControlsEnabled()) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }

    _timer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES] retain];
    [self currentIndexDidChange];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_statusBarWasHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // dismissed by someone else (not just covered by the share sheet)
    if ([self isBeingDismissed] || ![self presentingViewController]) {
        [self shutDown];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation) && orientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return 1 << UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark Pages

- (TRSPPageView *)pageForIndex:(NSInteger)index {
    for (TRSPPageView *page in _pages) {
        if (page.index == index) {
            return page;
        }
    }
    return nil;
}

- (BOOL)isCurrentPageIndex:(NSInteger)index {
    return !_closed && index == _currentIndex && _appeared;
}

- (void)tilePages {
    NSInteger count = [_items count];
    CGRect bounds = self.view.bounds;
    NSMutableArray *needed = [NSMutableArray array];
    for (NSInteger index = _currentIndex - 1; index <= _currentIndex + 1; index++) {
        if (index >= 0 && index < count) {
            [needed addObject:[NSNumber numberWithInteger:index]];
        }
    }
    NSMutableArray *spare = [NSMutableArray array];
    for (TRSPPageView *page in _pages) {
        if (![needed containsObject:[NSNumber numberWithInteger:page.index]]) {
            [spare addObject:page];
        }
    }
    for (NSNumber *number in needed) {
        NSInteger index = [number integerValue];
        if ([self pageForIndex:index]) {
            continue;
        }
        TRSPPageView *page = [spare lastObject];
        if (!page) {
            break;
        }
        [spare removeLastObject];
        [page showItem:[_items objectAtIndex:index] index:index];
        page.frame = CGRectMake(0, bounds.size.height * index, bounds.size.width, bounds.size.height);
        page.hidden = NO;
        [self loadThumbnailForItem:[_items objectAtIndex:index]];
        [self preparePage:page];
    }
    for (TRSPPageView *page in spare) {
        [page teardownPlayer];
        page.index = -1;
        page.hidden = YES;
    }
}

- (void)currentIndexDidChange {
    if (_closed || [_items count] == 0) {
        return;
    }
    _userPaused = NO;
    [self tilePages];
    for (TRSPPageView *page in _pages) {
        if (page.index == _currentIndex) {
            [page restart];
            [page play];
        } else {
            [page pause];
        }
    }
    // the current Short first, then the next one in the background
    [self loadItemAtIndex:_currentIndex];
    [self loadItemAtIndex:_currentIndex + 1];
    for (NSInteger index = _currentIndex + 1; index <= _currentIndex + 3 && index < (NSInteger)[_items count]; index++) {
        [self loadThumbnailForItem:[_items objectAtIndex:index]];
    }
    // forget streams of Shorts far away (each SABR stream runs a local server)
    for (NSInteger index = 0; index < (NSInteger)[_items count]; index++) {
        TRSPItem *item = [_items objectAtIndex:index];
        if (labs((long)(index - _currentIndex)) > 2 && item.state != TRSPItemIdle && item.state != TRSPItemLoading) {
            [item reset];
            item.thumbnail = nil;
            item.thumbnailRequested = NO;
        }
    }
    if (_currentIndex >= (NSInteger)[_items count] - 4) {
        [self loadMore];
    }
    [self updateNowPlaying];
}

#pragma mark Loading

- (void)loadThumbnailForItem:(TRSPItem *)item {
    if (item.thumbnail || item.thumbnailRequested) {
        return;
    }
    NSURL *url = [item.info objectForKey:TR_SHORT_THUMBNAIL];
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    item.thumbnailRequested = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [item retain];
    [self retain];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [TRSPScaledThumbnail(data) retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image && !_closed) {
                item.thumbnail = image;
                for (TRSPPageView *page in _pages) {
                    if (page.item == item) {
                        [page refresh];
                    }
                }
                if (item == [self currentItem]) {
                    [self updateNowPlaying];
                }
            }
            [image release];
            [item release];
            [self release];
        });
    }];
}

// custom server (2) first, then the highest format: SABR (5), HLS (4),
// progressive (1) - what -[YTStream internalSelectStream...] picks, but
// keeping the rest as fallbacks
static NSArray *TRSPOrderStreams(NSArray *streams) {
    NSMutableArray *usable = [NSMutableArray array];
    for (id stream in streams) {
        if (![stream respondsToSelector:@selector(format)]) continue;
        int format = [(id<TRSPMessages>)stream format];
        if (format == 5) {
            if ([stream respondsToSelector:@selector(isStreamBad)] && [(id<TRSPMessages>)stream isStreamBad]) continue;
        } else if (![stream respondsToSelector:@selector(URL)] || ![(id<TRSPMessages>)stream URL]) {
            continue;
        }
        [usable addObject:stream];
    }
    [usable sortUsingComparator:^NSComparisonResult(id a, id b) {
        int formatA = [(id<TRSPMessages>)a format], formatB = [(id<TRSPMessages>)b format];
        int rankA = formatA == 2 ? 100 : formatA, rankB = formatB == 2 ? 100 : formatB;
        if (rankA == rankB) return NSOrderedSame;
        return rankA > rankB ? NSOrderedAscending : NSOrderedDescending;
    }];
    return usable;
}

- (void)loadItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)[_items count]) {
        return;
    }
    TRSPItem *item = [_items objectAtIndex:index];
    if (item.state != TRSPItemIdle) {
        return;
    }
    item.state = TRSPItemLoading;
    [[self pageForIndex:index] refresh];
    NSUInteger generation = item.generation;
    NSString *videoID = [[item videoID] copy];
    BOOL wantVotes = PreferencesBoolValue(TRPreferences(), @"UseRTYDL", YES);
    [item retain];
    [self retain];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *errorMessage = nil;
        id video = nil;
        NSArray *streams = nil;
        long long likes = -1, dislikes = -1;
        NSMutableDictionary *details = [[NSMutableDictionary alloc] init];

        NSDictionary *json = TRSPFetchJSON(TRPlayerRequestURL(), TRPlayerRequestBody(videoID), TRSPAuthNone, &errorMessage);
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSString *status = [TRJSONUtils stringFromJSON:json keyPath:@"playabilityStatus.status"];
            if (status && ![status isEqualToString:@"OK"]) {
                errorMessage = [TRJSONUtils stringFromJSON:json keyPath:@"playabilityStatus.reason"] ?: status;
            } else {
                // Shorts from the recommendation feed arrive with nothing but
                // their ID - the captions come from here
                NSString *title = [TRJSONUtils stringFromJSON:json keyPath:@"videoDetails.title"];
                NSString *author = [TRJSONUtils stringFromJSON:json keyPath:@"videoDetails.author"];
                NSString *channelID = [TRJSONUtils stringFromJSON:json keyPath:@"videoDetails.channelId"];
                NSString *viewCount = [TRJSONUtils stringFromJSON:json keyPath:@"videoDetails.viewCount"];
                if (title) [details setObject:title forKey:TR_SHORT_TITLE];
                if (author) [details setObject:author forKey:TR_SHORT_AUTHOR];
                if (channelID) [details setObject:channelID forKey:TR_SHORT_CHANNEL_ID];
                if ([viewCount respondsToSelector:@selector(longLongValue)] && [viewCount longLongValue] > 0) {
                    [details setObject:[NSNumber numberWithLongLong:[viewCount longLongValue]] forKey:TR_SHORT_VIEWS];
                }
                TRVideoTranslator *translator = [[TRVideoTranslator alloc] init];
                video = [[translator translatePlayerResponse:json error:NULL] retain];
                [translator release];
                streams = [TRSPOrderStreams([video respondsToSelector:@selector(streams)] ? [(id<TRSPMessages>)video streams] : nil) retain];
                if ([streams count] == 0) {
                    errorMessage = TRSPText(@"No playable stream for this Short.", @"Для этого шортса нет подходящего потока.");
                }
                if ([video respondsToSelector:@selector(likesCount)] && [(id<TRSPMessages>)video likesCount] > 0) {
                    likes = (long long)[(id<TRSPMessages>)video likesCount];
                }
            }
        }
        if (!errorMessage && wantVotes) {
            NSURL *votesURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://returnyoutubedislikeapi.com/votes?videoId=%@", videoID]];
            NSDictionary *votes = TRSPFetchJSON(votesURL, nil, TRSPAuthNone, NULL);
            if ([votes isKindOfClass:[NSDictionary class]]) {
                if ([votes objectForKey:@"likes"] && likes < 0) likes = [[votes objectForKey:@"likes"] longLongValue];
                if ([votes objectForKey:@"dislikes"]) dislikes = [[votes objectForKey:@"dislikes"] longLongValue];
            }
        }
        [errorMessage retain];
        [pool release];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_closed && item.generation == generation) {
                if (errorMessage) {
                    item.state = TRSPItemFailed;
                    item.errorMessage = errorMessage;
                } else {
                    item.video = video;
                    item.streams = streams;
                    item.streamIndex = 0;
                    item.state = TRSPItemReady;
                }
                if (likes >= 0) item.likes = likes;
                if (dislikes >= 0) item.dislikes = dislikes;
                if ([details count] > 0) {
                    NSMutableDictionary *info = [[item.info mutableCopy] autorelease];
                    for (NSString *key in details) {
                        if (![info objectForKey:key]) [info setObject:[details objectForKey:key] forKey:key];
                    }
                    item.info = info;
                }
                TFLLog(@"Shorts: %@ loaded, %u streams, error %@", videoID, (unsigned)[streams count], errorMessage);
                TRSPPageView *page = nil;
                for (TRSPPageView *candidate in _pages) {
                    if (candidate.item == item) page = candidate;
                }
                if (page) {
                    [page refresh];
                    [self preparePage:page];
                }
                if (item == [self currentItem]) {
                    [self updateNowPlaying];
                }
            }
            [video release];
            [streams release];
            [details release];
            [errorMessage release];
            [videoID release];
            [item release];
            [self release];
        });
    });
}

- (TRSPItem *)currentItem {
    return (_currentIndex >= 0 && _currentIndex < (NSInteger)[_items count]) ? [_items objectAtIndex:_currentIndex] : nil;
}

// Hooks the page up to its item's current stream (starting SABR when
// that's what it is). Only the current Short and the next one get a player.
- (void)preparePage:(TRSPPageView *)page {
    TRSPItem *item = page.item;
    if (_closed || !item || item.state != TRSPItemReady || page.player || page.waitingForSabrPort) {
        return;
    }
    if (page.index != _currentIndex && page.index != _currentIndex + 1) {
        return;
    }
    id stream = [item currentStream];
    if (!stream) {
        item.state = TRSPItemFailed;
        [page refresh];
        return;
    }
    if ([(id<TRSPMessages>)stream format] == 5 && [stream isKindOfClass:[TRSabrStream class]]) {
        TRSabrStream *sabrStream = stream;
        if (item.startedSabrStream != sabrStream) {
            [item stopStreams];
            __block TRSPViewController *controller = self; // not retained - reset to a no-op in -[TRSPItem stopStreams]
            __block TRSPItem *blockItem = item;
            sabrStream.currentPlayerTimeFunction = ^double {
                return 0;
            };
            sabrStream.reloadPlayerFunction = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (TRSPControllerIsAlive(controller)) {
                        [controller sabrStreamNeedsReloadForItem:blockItem];
                    }
                });
            };
            sabrStream.authentication = TRCurrentSignedInAuth();
            [sabrStream start];
            item.startedSabrStream = sabrStream;
        }
        if (sabrStream.port == 0) {
            // the local server picks its port on its own thread; -tick
            // attaches the player once it has one
            page.waitingForSabrPort = YES;
            page.sabrWaitStarted = CFAbsoluteTimeGetCurrent();
            [page refresh];
            return;
        }
    }
    [page attachPlayerWithURL:[(id<TRSPMessages>)stream URL]];
    if (page.index == _currentIndex && !_userPaused) {
        [page play];
    }
}

- (void)sabrStreamNeedsReloadForItem:(TRSPItem *)item {
    // item may be gone already - only compare the pointer
    if (_closed || [_items indexOfObjectIdenticalTo:item] == NSNotFound) {
        return;
    }
    TRSPPageView *page = nil;
    for (TRSPPageView *candidate in _pages) {
        if (candidate.item == item) page = candidate;
    }
    TRSabrStream *stream = item.startedSabrStream;
    if (!stream) {
        return;
    }
    double position = [page currentTime];
    if (stream.isStreamBad) {
        [self advanceStreamForItem:item page:page];
        return;
    }
    // server went away (app was suspended): start it again where we were
    [page teardownPlayer];
    [item stopStreams];
    if (page) {
        [self preparePage:page];
        if (position > 0 && page.player) {
            [page.player seekToTime:CMTimeMakeWithSeconds(position, 600)];
        }
    }
}

- (void)advanceStreamForItem:(TRSPItem *)item page:(TRSPPageView *)page {
    [page teardownPlayer];
    [item stopStreams];
    item.streamIndex = item.streamIndex + 1;
    if (![item currentStream]) {
        item.state = TRSPItemFailed;
        if (!item.errorMessage) {
            item.errorMessage = TRSPText(@"Couldn't play this Short.", @"Не удалось воспроизвести этот шортс.");
        }
        [page refresh];
        return;
    }
    TFLLog(@"Shorts: %@ falling back to stream %u (format %d)", [item videoID], (unsigned)item.streamIndex, [(id<TRSPMessages>)[item currentStream] format]);
    if (page) {
        [self preparePage:page];
    }
}

- (void)pagePlayerFailed:(TRSPPageView *)page {
    if (_closed || !page.item) {
        return;
    }
    [self advanceStreamForItem:page.item page:page];
}

- (void)pageWantsRetry:(TRSPPageView *)page {
    TRSPItem *item = page.item;
    [page teardownPlayer];
    [item reset];
    [page refresh];
    [self loadItemAtIndex:page.index];
}

// More Shorts near the end of the list: YouTube's own Shorts
// recommendations after the Short that was tapped (personalised when
// someone is signed in), or - if that endpoint fails - the Shorts search
// the side-menu feed uses.
- (void)loadMore {
    if (_loadingMore || !_hasMore || _closed) {
        return;
    }
    _loadingMore = YES;
    BOOL useSequence = !_sequenceFailed;
    NSString *continuation = [(useSequence ? _sequenceContinuation : _continuation) copy];
    NSString *seed = [_seedVideoID copy];
    NSString *query = [TRShortsQuery() copy];
    [self retain];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        YoutubeClientType *client = [YoutubeClientType webMobileClient];
        NSMutableArray *found = [[NSMutableArray alloc] init];
        NSString *nextContinuation = nil;
        BOOL failed = NO;
        if (useSequence) {
            NSString *sequenceParams = continuation ?: TRSPSequenceParamsForVideo(seed);
            NSMutableDictionary *body = [TRRequestBuilder baseBodyWithClient:client];
            if (sequenceParams) {
                [body setObject:sequenceParams forKey:@"sequenceParams"];
            }
            id json = sequenceParams ? TRSPFetchJSON([NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/reel/reel_watch_sequence?prettyPrint=false"], [TRRequestBuilder serializeBody:body], TRSPAuthIfSignedIn, NULL) : nil;
            TRSPCollectSequence(json, found, &nextContinuation);
            failed = ([found count] == 0);
        } else {
            NSData *body = continuation
                ? [TRRequestBuilder continueWithContext:continuation client:client]
                : [TRRequestBuilder searchBodyWithQuery:query type:TR_SHORTS_SEARCH_TYPE sortBy:0 duration:0 hasCC:NO posted:0 client:client];
            id json = TRSPFetchJSON([NSURL URLWithString:@"https://www.youtube.com/youtubei/v1/search?prettyPrint=false"], body, TRSPAuthNone, NULL);
            TRCollectShortsFromJSON(json, found, &nextContinuation);
            failed = (json == nil);
        }
        [nextContinuation retain];
        [pool release];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_closed) {
                NSUInteger added = 0;
                for (NSDictionary *info in found) {
                    NSString *videoID = [info objectForKey:TR_SHORT_VIDEO_ID];
                    if ([_knownIDs containsObject:videoID]) continue;
                    [_knownIDs addObject:videoID];
                    TRSPItem *item = [[TRSPItem alloc] initWithInfo:info];
                    [_items addObject:item];
                    [item release];
                    added++;
                }
                if (useSequence) {
                    if (failed) {
                        // fall back to the search for the rest of this session
                        _sequenceFailed = YES;
                        TFLLog(@"Shorts: recommendations unavailable, using the Shorts search");
                    }
                    [_sequenceContinuation release];
                    _sequenceContinuation = [nextContinuation retain];
                    _hasMore = YES;
                } else {
                    [_continuation release];
                    _continuation = [nextContinuation retain];
                    _hasMore = (nextContinuation != nil) || (!failed && added > 0 && continuation == nil);
                }
                _emptyLoads = added > 0 ? 0 : _emptyLoads + 1;
                if (_emptyLoads >= 4 || (!useSequence && failed)) _hasMore = NO;
                if (useSequence && !failed && !nextContinuation) _sequenceFailed = YES;
                TFLLog(@"Shorts: loaded %u more (%u total) from %@, more: %d", (unsigned)added, (unsigned)[_items count], useSequence ? @"recommendations" : @"search", _hasMore);
                _loadingMore = NO;
                [self layoutPlayer];
                [self tilePages];
                [self loadItemAtIndex:_currentIndex + 1];
                // keep going until something new turns up near the end
                if (_hasMore && (added == 0 || _currentIndex >= (NSInteger)[_items count] - 4)) {
                    [self loadMore];
                }
            }
            [found release];
            [nextContinuation release];
            [continuation release];
            [seed release];
            [query release];
            [self release];
        });
    });
}

#pragma mark Ticks

- (void)tick {
    if (_closed) {
        return;
    }
    for (TRSPPageView *page in _pages) {
        if (!page.waitingForSabrPort) {
            continue;
        }
        if (page.item.startedSabrStream.port != 0) {
            page.waitingForSabrPort = NO;
            [self preparePage:page];
        } else if (CFAbsoluteTimeGetCurrent() - page.sabrWaitStarted > 10) {
            page.waitingForSabrPort = NO;
            [self advanceStreamForItem:page.item page:page];
        }
    }
    [self updateProgress];
}

- (void)updateProgress {
    TRSPPageView *page = [self pageForIndex:_currentIndex];
    double duration = [page duration];
    double time = [page currentTime];
    CGFloat fraction = duration > 0 ? MIN(1.0, MAX(0.0, time / duration)) : 0;
    _progressFill.frame = CGRectMake(0, 0, _progressTrack.bounds.size.width * fraction, _progressTrack.bounds.size.height);
}

- (void)updateNowPlaying {
    if (!TRLockScreenControlsEnabled()) {
        return;
    }
    TRSPItem *item = [self currentItem];
    if (!item) {
        return;
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    NSString *title = [item.info objectForKey:TR_SHORT_TITLE];
    NSString *author = [item.info objectForKey:TR_SHORT_AUTHOR];
    if (title) [info setObject:title forKey:MPMediaItemPropertyTitle];
    if (author) [info setObject:author forKey:MPMediaItemPropertyArtist];
    [info setObject:@"YouTube Shorts" forKey:MPMediaItemPropertyAlbumTitle];
    if (item.thumbnail) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:item.thumbnail];
        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
        [artwork release];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
}

#pragma mark Scrolling and gestures

- (void)settleScrolling {
    CGFloat height = _scrollView.bounds.size.height;
    if (height <= 0) {
        return;
    }
    NSInteger index = (NSInteger)lround(_scrollView.contentOffset.y / height);
    index = MAX(0, MIN(index, (NSInteger)[_items count] - 1));
    if (index != _currentIndex) {
        _currentIndex = index;
        [self currentIndexDidChange];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // make sure the page being dragged in already shows something
    CGFloat height = scrollView.bounds.size.height;
    if (height > 0) {
        NSInteger visible = (NSInteger)floor(scrollView.contentOffset.y / height);
        if (visible < _currentIndex - 1 || visible > _currentIndex) {
            [self settleScrolling];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self settleScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self settleScrolling];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self settleScrolling];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // buttons keep their taps
    return ![touch.view isKindOfClass:[UIButton class]];
}

- (void)singleTapped:(UITapGestureRecognizer *)recognizer {
    TRSPPageView *page = [self pageForIndex:_currentIndex];
    if (!page.player) {
        return;
    }
    if ([page isPlaying]) {
        _userPaused = YES;
        [page pause];
        [page flashPlayIcon:YES];
    } else {
        _userPaused = NO;
        [page play];
        [page flashPlayIcon:NO];
    }
}

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer {
    TRSPPageView *page = [self pageForIndex:_currentIndex];
    if (!page.item) {
        return;
    }
    [page flashLike];
    if (page.item.likeState != TRLikeStateLiked) {
        [self pageWantsLike:page dislike:NO];
    }
}

#pragma mark Rating, sharing, leaving

- (void)likeStateDidChange:(NSNotification *)notification {
    NSString *videoID = [notification object];
    for (TRSPItem *item in _items) {
        if ([[item videoID] isEqualToString:videoID] && !item.ratingInFlight) {
            item.likeState = TRGetCachedLikeState(videoID);
        }
    }
    for (TRSPPageView *page in _pages) {
        [page refresh];
    }
}

- (void)pageWantsLike:(TRSPPageView *)page dislike:(BOOL)dislike {
    TRSPItem *item = page.item;
    if (!item || item.ratingInFlight) {
        return;
    }
    if (!TRCurrentSignedInAuth()) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:TRSPText(@"Sign in to YouTube to rate videos.", @"Войдите в YouTube, чтобы оценивать видео.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    TRLikeState previous = item.likeState;
    TRLikeState wanted;
    NSString *endpoint;
    if (dislike) {
        wanted = previous == TRLikeStateDisliked ? TRLikeStateNeutral : TRLikeStateDisliked;
    } else {
        wanted = previous == TRLikeStateLiked ? TRLikeStateNeutral : TRLikeStateLiked;
    }
    endpoint = wanted == TRLikeStateLiked ? @"like/like" : (wanted == TRLikeStateDisliked ? @"like/dislike" : @"like/removelike");

    // optimistic: show it right away, undo if the request fails
    item.likeState = wanted;
    item.ratingInFlight = YES;
    if (item.likes >= 0) {
        if (wanted == TRLikeStateLiked) item.likes = item.likes + 1;
        else if (previous == TRLikeStateLiked && item.likes > 0) item.likes = item.likes - 1;
    }
    [page refresh];

    NSString *videoID = [[item videoID] copy];
    [item retain];
    [self retain];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/youtubei/v1/%@?prettyPrint=false", endpoint]];
        NSString *errorMessage = nil;
        id json = TRSPFetchJSON(url, [TRRequestBuilder likeBodyWithVideoId:videoID client:[YoutubeClientType webMobileClient]], TRSPAuthRequired, &errorMessage);
        BOOL succeeded = (json != nil);
        [errorMessage retain];
        [pool release];
        dispatch_async(dispatch_get_main_queue(), ^{
            item.ratingInFlight = NO;
            if (succeeded) {
                TRSetCachedLikeState(videoID, wanted);
            } else {
                TFLLog(@"Shorts: rating %@ failed: %@", videoID, errorMessage);
                item.likeState = previous;
                if (item.likes >= 0) {
                    if (wanted == TRLikeStateLiked && item.likes > 0) item.likes = item.likes - 1;
                    else if (previous == TRLikeStateLiked) item.likes = item.likes + 1;
                }
                if (!_closed) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage ?: TRSPText(@"Couldn't rate this video.", @"Не удалось оценить видео.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            }
            for (TRSPPageView *candidate in _pages) {
                if (candidate.item == item) [candidate refresh];
            }
            [errorMessage release];
            [videoID release];
            [item release];
            [self release];
        });
    });
}

- (void)pageWantsShare:(TRSPPageView *)page {
    NSString *videoID = [page.item videoID];
    if (!videoID) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://youtube.com/shorts/%@", videoID]];
    Class activityClass = NSClassFromString(@"UIActivityViewController");
    if (activityClass) {
        NSString *title = [page.item.info objectForKey:TR_SHORT_TITLE];
        NSArray *activityItems = title ? [NSArray arrayWithObjects:title, url, nil] : [NSArray arrayWithObject:url];
        UIViewController *activity = [[activityClass alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:nil];
        [activity release];
        return;
    }
    // iOS 5
    [_shareVideoID release];
    _shareVideoID = [videoID copy];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:TRSPText(@"Cancel", @"Отмена") destructiveButtonTitle:nil otherButtonTitles:TRSPText(@"Copy Link", @"Скопировать ссылку"), TRSPText(@"Open in Safari", @"Открыть в Safari"), nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!_shareVideoID || buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://youtube.com/shorts/%@", _shareVideoID]];
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [UIPasteboard generalPasteboard].URL = url;
        [UIPasteboard generalPasteboard].string = [url absoluteString];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)canOpenRegularPlayer {
    return _openInRegularPlayer != nil;
}

- (void)pageWantsRegularPlayer:(TRSPPageView *)page {
    NSString *videoID = [[[page.item videoID] copy] autorelease];
    void (^open)(NSString *) = [[_openInRegularPlayer copy] autorelease];
    [self closeWithCompletion:^{
        if (open && videoID) {
            open(videoID);
        }
    }];
}

- (void)closeTapped {
    [self closeWithCompletion:nil];
}

- (void)shutDown {
    if (_closed) {
        return;
    }
    _closed = YES;
    [_timer invalidate];
    [_timer release];
    _timer = nil;
    for (TRSPPageView *page in _pages) {
        [page teardownPlayer];
        page.controller = nil;
    }
    for (TRSPItem *item in _items) {
        [item stopStreams];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    if (!TRActivePlayerController()) {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
    if (gTRSPVisibleController == self) {
        gTRSPVisibleController = nil;
    }
}

- (void)closeWithCompletion:(void (^)(void))completion {
    [self shutDown];
    if (!_statusBarWasHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    UIViewController *presenter = [self respondsToSelector:@selector(presentingViewController)] ? [self presentingViewController] : [self parentViewController];
    [presenter dismissViewControllerAnimated:YES completion:completion];
}

- (void)dealloc {
    [gTRSPLiveControllers removeObject:[NSValue valueWithPointer:self]];
    [self shutDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (TRSPPageView *page in _pages) {
        page.controller = nil;
    }
    [_items release];
    [_knownIDs release];
    [_pages release];
    [_scrollView setDelegate:nil];
    [_scrollView release];
    [_closeButton release];
    [_headerLabel release];
    [_progressTrack release];
    [_progressFill release];
    [_continuation release];
    [_sequenceContinuation release];
    [_seedVideoID release];
    [_openInRegularPlayer release];
    [_shareVideoID release];
    [super dealloc];
}

@end

#pragma mark - Presenting

static UIViewController *TRSPTopViewController(void) {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        window = [windows count] > 0 ? [windows objectAtIndex:0] : nil;
    }
    UIViewController *controller = window.rootViewController;
    if (!controller) {
        // some versions only put a view into the window
        for (UIView *subview in window.subviews) {
            UIResponder *responder = [subview nextResponder];
            if ([responder isKindOfClass:[UIViewController class]]) {
                controller = (UIViewController *)responder;
                break;
            }
        }
    }
    while (controller.presentedViewController && !controller.presentedViewController.isBeingDismissed) {
        controller = controller.presentedViewController;
    }
    return controller;
}

BOOL TRPresentShortsPlayerWithSequence(NSArray *sequence, NSUInteger index, void (^openInRegularPlayer)(NSString *videoID)) {
    if ([sequence count] == 0 || index >= [sequence count] || gTRSPVisibleController) {
        return NO;
    }
    UIViewController *presenter = TRSPTopViewController();
    if (!presenter || ![presenter respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        return NO;
    }
    NSDictionary *first = [sequence objectAtIndex:index];
    TFLLog(@"Shorts player: %@ (%u of %u)", [first objectForKey:TR_SHORT_VIDEO_ID], (unsigned)index + 1, (unsigned)[sequence count]);
    TRSPViewController *controller = [[TRSPViewController alloc] initWithSequence:sequence startIndex:index openInRegularPlayer:openInRegularPlayer];
    gTRSPVisibleController = controller;
    [presenter presentViewController:controller animated:YES completion:nil];
    [controller release];
    return YES;
}

BOOL TRPresentShortsPlayer(NSString *videoID, void (^openInRegularPlayer)(NSString *videoID)) {
    if (![videoID isKindOfClass:[NSString class]] || [videoID length] == 0) {
        return NO;
    }
    NSUInteger index = 0;
    NSArray *sequence = TRShortsSequenceAround(videoID, &index);
    if (sequence && TRIsShortsCategoryVideoID(videoID)) {
        // the side-menu feed is a search for #shorts - after the tapped
        // Short, play recommendations like the real Shorts tab does
        sequence = [NSArray arrayWithObject:[sequence objectAtIndex:index]];
        index = 0;
    }
    if (!sequence) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
            videoID, TR_SHORT_VIDEO_ID,
            [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/hqdefault.jpg", videoID]], TR_SHORT_THUMBNAIL,
            nil];
        sequence = [NSArray arrayWithObject:info];
        index = 0;
    }
    return TRPresentShortsPlayerWithSequence(sequence, index, openInRegularPlayer);
}
