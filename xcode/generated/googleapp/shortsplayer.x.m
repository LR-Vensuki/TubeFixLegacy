#line 1 "googleapp/shortsplayer.x"













#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "general.h"
#import "TRShorts.h"
#import "TRShortsPlayer.h"

@protocol TFLShortsNavigation
- (void)showWatchWithVideoID:(id)videoID source:(int)source fromView:(id)view;
- (NSString *)ID;
@end



void TRGatedHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);

typedef void (*TRShowWatchIMP)(id, SEL, id, int, id);


static NSMutableDictionary *gTROriginalShowWatchWithVideo = nil;
static NSMutableDictionary *gTROriginalShowWatchWithVideoID = nil;

static BOOL gTRBypassShortsPlayer = NO;

static TRShowWatchIMP TROriginalIMP(NSDictionary *table, id object) {
    for (Class cls = object_getClass(object); cls; cls = class_getSuperclass(cls)) {
        NSValue *value = [table objectForKey:NSStringFromClass(cls)];
        if (value) {
            return (TRShowWatchIMP)[value pointerValue];
        }
    }
    return NULL;
}

static BOOL TRShouldOpenInShortsPlayer(void) {
    return !gTRBypassShortsPlayer && !TRShortsPlayerIsVisible() && TRShortsPlayerEnabled();
}




static void TROpenRegularPlayer(id navigation, SEL selector, TRShowWatchIMP original, id videoOrID, NSString *tappedID, NSString *chosenID, int source, id view) {
    gTRBypassShortsPlayer = YES;
    if ([chosenID isEqualToString:tappedID] || ![navigation respondsToSelector:@selector(showWatchWithVideoID:source:fromView:)]) {
        if (original) {
            original(navigation, selector, videoOrID, source, view);
        }
    } else {
        [(id<TFLShortsNavigation>)navigation showWatchWithVideoID:chosenID source:source fromView:view];
    }
    gTRBypassShortsPlayer = NO;
}

static void TRShowWatchWithVideo(id self, SEL _cmd, id video, int source, id view) {
    TRShowWatchIMP original = TROriginalIMP(gTROriginalShowWatchWithVideo, self);
    NSString *videoID = [video respondsToSelector:@selector(ID)] ? [(id<TFLShortsNavigation>)video ID] : nil;
    if (TRShouldOpenInShortsPlayer() && [videoID isKindOfClass:[NSString class]] && TRVideoIsShort(video)) {
        BOOL shown = TRPresentShortsPlayer(videoID, ^(NSString *chosenID) {
            TROpenRegularPlayer(self, _cmd, original, video, videoID, chosenID, source, view);
        });
        if (shown) {
            return;
        }
    }
    if (original) {
        original(self, _cmd, video, source, view);
    }
}

static void TRShowWatchWithVideoID(id self, SEL _cmd, id videoID, int source, id view) {
    TRShowWatchIMP original = TROriginalIMP(gTROriginalShowWatchWithVideoID, self);
    if (TRShouldOpenInShortsPlayer() && [videoID isKindOfClass:[NSString class]] && TRIsKnownShortVideoID(videoID)) {
        BOOL shown = TRPresentShortsPlayer(videoID, ^(NSString *chosenID) {
            gTRBypassShortsPlayer = YES;
            if (original) {
                original(self, _cmd, chosenID, source, view);
            }
            gTRBypassShortsPlayer = NO;
        });
        if (shown) {
            return;
        }
    }
    if (original) {
        original(self, _cmd, videoID, source, view);
    }
}

static BOOL TRClassImplementsItself(Class cls, SEL selector) {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    BOOL found = NO;
    for (unsigned int i = 0; i < count && !found; i++) {
        found = (method_getName(methods[i]) == selector);
    }
    free(methods);
    return found;
}

static void TRHookShowWatch(Class cls, SEL selector, IMP replacement, NSMutableDictionary *originals) {
    if (!TRClassImplementsItself(cls, selector)) {
        return;
    }
    IMP original = NULL;
    MSHookMessageEx(cls, selector, replacement, &original);
    if (original) {
        [originals setObject:[NSValue valueWithPointer:(void *)original] forKey:NSStringFromClass(cls)];
        TFLLog(@"Shorts player: hooked -[%@ %@]", NSStringFromClass(cls), NSStringFromSelector(selector));
    }
}

static __attribute__((constructor)) void _logosLocalCtor_7c1a0202(int __unused argc, char __unused **argv, char __unused **envp) {
    if (!TRShouldLoadGoogleHooks()) {
        return;
    }
    gTROriginalShowWatchWithVideo = [[NSMutableDictionary alloc] init];
    gTROriginalShowWatchWithVideoID = [[NSMutableDictionary alloc] init];
    SEL withVideo = @selector(showWatchWithVideo:source:fromView:);
    SEL withVideoID = @selector(showWatchWithVideoID:source:fromView:);

    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        const char *name = class_getName(classes[i]);
        if (!name || strncmp(name, "YT", 2) != 0) {
            continue;
        }
        TRHookShowWatch(classes[i], withVideo, (IMP)TRShowWatchWithVideo, gTROriginalShowWatchWithVideo);
        TRHookShowWatch(classes[i], withVideoID, (IMP)TRShowWatchWithVideoID, gTROriginalShowWatchWithVideoID);
    }
    free(classes);
}
