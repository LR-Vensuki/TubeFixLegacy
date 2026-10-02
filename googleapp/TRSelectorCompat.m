// TRSelectorCompat.m
// TubeFixLegacy
//
// The translators build the app's model objects (YTVideo, YTChannel,
// YTPage, ...) with the initializers of the versions they were written
// against; 2.1.x and 2.2.x run the 2.0.0 code paths. If one of those
// initializers doesn't exist in such a version, sending it would kill the
// app with "unrecognized selector". On versions that weren't checked
// against the real binaries (see TRIsVerifiedGoogleVersion) the model
// classes get a forwarding fallback instead: the call is remapped onto the
// closest initializer of the same family that the class does have, with
// the arguments matched up by keyword (title: -> title:, duration: ->
// duration:, ...) and anything the old call didn't carry left at 0/nil.
//
// Verified versions never install any of this.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "general.h"
#import "../common/TRVersionSupport.h"

// The exact declarations the tweak's 2.x code paths are compiled against.
// Only used to recover the caller's argument types at runtime (via
// protocol_getMethodDescription) - nothing is ever sent through it.
@protocol TRCompatModelInitializers
- (id)initWithID:(id)ID title:(id)title description:(id)description uploaderDisplayName:(id)uploaderDisplayName uploaderChannelID:(id)uploaderChannelID uploadedDate:(id)uploadedDate publishedDate:(id)publishedDate duration:(unsigned int)duration viewCount:(unsigned long long)viewCount likesCount:(unsigned long long)likesCount dislikesCount:(unsigned long long)dislikesCount ratingAllowed:(BOOL)ratingAllowed state:(id)state streams:(id)streams thumbnailURLs:(id)thumbnailURLs subtitlesTracksURL:(id)subtitlesTracksURL commentsAllowed:(BOOL)commentsAllowed commentsURL:(id)commentsURL commentsCountHint:(unsigned long long)commentsCountHint relatedURL:(id)relatedURL claimed:(BOOL)claimed monetized:(BOOL)monetized monetizedCountries:(id)monetizedCountries listed:(BOOL)listed categoryLabel:(id)categoryLabel categoryTerm:(id)categoryTerm adultContent:(BOOL)adultContent editURL:(id)editURL paidContent:(BOOL)paidContent privateContent:(BOOL)privateContent videoPro:(id)videoPro liveEventURL:(id)liveEventURL currentViewers:(int)currentViewers;
- (id)initWithDisplayName:(id)displayName channelID:(id)channelID title:(id)title summary:(id)summary updated:(id)updated videoCount:(unsigned long long)videoCount thumbnailURL:(id)thumbnailURL subscribersCount:(unsigned long long)subscribersCount paidContent:(BOOL)paidContent parentChannelURLs:(id)parentChannelURLs;
- (id)initWithID:(id)ID title:(id)title summary:(id)summary authorDisplayName:(id)authorDisplayName updated:(id)updated thumbnailURLs:(id)thumbnailURLs contentURL:(id)contentURL editURL:(id)editURL size:(unsigned int)size isPrivate:(BOOL)isPrivate;
- (id)initWithAuthorDisplayName:(id)authorDisplayName authorUserID:(id)authorUserID action:(int)action target:(id)target targetDisplayName:(id)targetDisplayName when:(id)when video:(id)video groupID:(id)groupID feedURL:(id)feedURL title:(id)title;
- (id)initWithEntries:(id)entries totalResults:(int)totalResults entriesPerPage:(int)entriesPerPage startIndex:(int)startIndex nextURL:(id)nextURL previousURL:(id)previousURL;
- (id)initWithDisplayName:(id)displayName channelID:(id)channelID type:(int)type publishedDate:(id)publishedDate updatedDate:(id)updatedDate countHint:(unsigned long long)countHint unreadCount:(unsigned long long)unreadCount editURL:(id)editURL thumbnailURL:(id)thumbnailURL;
- (id)initWithDisplayName:(id)displayName hasChannel:(BOOL)hasChannel channelID:(id)channelID channelName:(id)channelName eligibleForChannel:(BOOL)eligibleForChannel googlePlusUserID:(id)googlePlusUserID age:(unsigned int)age thumbnailURL:(id)thumbnailURL uploadsURL:(id)uploadsURL playlistsURL:(id)playlistsURL uploadedCount:(unsigned long long)uploadedCount favoritesCount:(unsigned long long)favoritesCount subscriptionsCount:(unsigned long long)subscriptionsCount uploadViewsCount:(unsigned long long)uploadViewsCount channelViewsCount:(unsigned long long)channelViewsCount subscribersCount:(unsigned long long)subscribersCount;
- (id)initWithLanguageCode:(id)languageCode languageName:(id)languageName trackName:(id)trackName format:(id)format;
- (id)initWithTitle:(id)title content:(id)content authorDisplayName:(id)authorDisplayName publishedDate:(id)publishedDate isSpam:(BOOL)isSpam;
- (id)initWithCode:(int)code reason:(id)reason;
- (id)initWithTerm:(id)term label:(id)label browsableCountries:(id)browsableCountries;
- (id)initWithExpirationInterval:(double)expirationInterval countLimit:(unsigned int)countLimit;
@end

@protocol TRCompatModelFactories
+ (id)streamWithURL:(id)URL MIMEType:(id)MIMEType format:(int)format;
+ (id)streamWithURL:(id)URL format:(int)format encrypted:(BOOL)encrypted;
@end

// class -> NSValue(IMP) of what methodSignatureForSelector: /
// forwardInvocation: did before we were added
static NSMutableDictionary *gTRInheritedSignatureIMPs = nil;
static NSMutableDictionary *gTRInheritedForwardIMPs = nil;
static NSMutableSet *gTRLoggedRemaps = nil;

static NSString *TRCompatKey(Class cls) {
    return [NSString stringWithFormat:@"%s%s", class_isMetaClass(cls) ? "+" : "-", class_getName(cls)];
}

// walks up from the receiver's class to the first class we patched
static IMP TRCompatInheritedIMP(NSDictionary *table, Class cls) {
    for (Class current = cls; current; current = class_getSuperclass(current)) {
        NSValue *value = [table objectForKey:TRCompatKey(current)];
        if (value) {
            return (IMP)[value pointerValue];
        }
    }
    return NULL;
}

// "initWithDisplayName:channelID:" -> ("displayname", "channelid"); the
// family prefix (initWith / streamWith / init) is stripped off the first
// keyword so initWithTitle: and title: line up.
static NSArray *TRCompatKeywords(SEL sel, NSString **familyOut) {
    NSArray *parts = [NSStringFromSelector(sel) componentsSeparatedByString:@":"];
    NSMutableArray *keywords = [NSMutableArray array];
    for (NSUInteger i = 0; i + 1 < [parts count]; i++) {
        NSString *part = [parts objectAtIndex:i];
        if (i == 0) {
            NSRange with = [part rangeOfString:@"With"];
            if (with.location != NSNotFound) {
                if (familyOut) *familyOut = [part substringToIndex:NSMaxRange(with)];
                part = [part substringFromIndex:NSMaxRange(with)];
            } else if (familyOut) {
                *familyOut = part;
            }
        }
        [keywords addObject:[part lowercaseString]];
    }
    return keywords;
}

static BOOL TRCompatIsKnownFamily(SEL sel) {
    NSString *name = NSStringFromSelector(sel);
    return [name hasPrefix:@"initWith"] || [name hasPrefix:@"streamWith"];
}

// best initializer of the same family the class really implements. The
// strict pass also wants the same first keyword (initWithID: vs
// initWithTitle: are different things); if nothing passes that, a
// candidate sharing at least half of the keywords is accepted.
static SEL TRCompatBestSelector(Class cls, SEL missing, NSString *family, NSArray *wanted, BOOL strict) {
    SEL best = NULL;
    NSInteger bestScore = NSIntegerMin;
    for (Class current = cls; current; current = class_getSuperclass(current)) {
        unsigned int count = 0;
        Method *methods = class_copyMethodList(current, &count);
        for (unsigned int i = 0; i < count; i++) {
            SEL candidate = method_getName(methods[i]);
            if (candidate == missing) continue;
            NSString *candidateFamily = nil;
            NSArray *have = TRCompatKeywords(candidate, &candidateFamily);
            if (![candidateFamily isEqualToString:family] || [have count] == 0) {
                continue;
            }
            if (strict && ![[have objectAtIndex:0] isEqualToString:[wanted objectAtIndex:0]]) {
                continue;
            }
            NSInteger shared = 0;
            for (NSString *keyword in have) {
                if ([wanted containsObject:keyword]) shared++;
            }
            if (!strict && (shared < 2 || shared * 2 < (NSInteger)[wanted count])) {
                continue;
            }
            NSInteger score = shared * 4 - (NSInteger)([have count] - shared) - (NSInteger)([wanted count] - shared);
            if (score > bestScore) {
                bestScore = score;
                best = candidate;
            }
        }
        free(methods);
        if (best) break; // prefer the most derived class that has one
    }
    return best;
}

static SEL TRCompatReplacementSelector(Class cls, SEL missing) {
    NSString *family = nil;
    NSArray *wanted = TRCompatKeywords(missing, &family);
    if (!family || [wanted count] == 0) {
        return NULL;
    }
    SEL best = TRCompatBestSelector(cls, missing, family, wanted, YES);
    return best ?: TRCompatBestSelector(cls, missing, family, wanted, NO);
}

static long long TRCompatReadInteger(const char *type, const void *buffer) {
    switch (type[0]) {
        case 'c': return *(const signed char *)buffer;
        case 'C': return *(const unsigned char *)buffer;
        case 'B': return *(const bool *)buffer;
        case 's': return *(const short *)buffer;
        case 'S': return *(const unsigned short *)buffer;
        case 'i': return *(const int *)buffer;
        case 'I': return *(const unsigned int *)buffer;
        case 'l': return *(const long *)buffer;
        case 'L': return *(const unsigned long *)buffer;
        case 'q': return *(const long long *)buffer;
        case 'Q': return (long long)*(const unsigned long long *)buffer;
        case 'f': return (long long)*(const float *)buffer;
        case 'd': return (long long)*(const double *)buffer;
        default: return 0;
    }
}

static BOOL TRCompatIsNumeric(const char *type) {
    return type[0] && strchr("cCBsSiIlLqQfd", type[0]) != NULL;
}

static void TRCompatWriteNumber(const char *type, void *buffer, long long integer, double real, BOOL useReal) {
    switch (type[0]) {
        // 'c' is BOOL in every initializer this handles
        case 'c': *(signed char *)buffer = (useReal ? real != 0 : integer != 0) ? 1 : 0; break;
        case 'C': *(unsigned char *)buffer = (unsigned char)integer; break;
        case 'B': *(bool *)buffer = (integer != 0 || real != 0); break;
        case 's': *(short *)buffer = (short)integer; break;
        case 'S': *(unsigned short *)buffer = (unsigned short)integer; break;
        case 'i': *(int *)buffer = (int)integer; break;
        case 'I': *(unsigned int *)buffer = (unsigned int)integer; break;
        case 'l': *(long *)buffer = (long)integer; break;
        case 'L': *(unsigned long *)buffer = (unsigned long)integer; break;
        case 'q': *(long long *)buffer = integer; break;
        case 'Q': *(unsigned long long *)buffer = (unsigned long long)integer; break;
        case 'f': *(float *)buffer = useReal ? (float)real : (float)integer; break;
        case 'd': *(double *)buffer = useReal ? real : (double)integer; break;
        default: break;
    }
}

// strips type qualifiers (r, n, N, o, O, R, V) from an argument type
static const char *TRCompatBareType(const char *type) {
    while (*type && strchr("rnNoORV", *type)) type++;
    return type;
}

static NSMethodSignature *TRCompat_methodSignatureForSelector(id self, SEL _cmd, SEL sel) {
    Class cls = object_getClass(self);
    IMP inherited = TRCompatInheritedIMP(gTRInheritedSignatureIMPs, cls);
    NSMethodSignature *signature = inherited ? ((NSMethodSignature *(*)(id, SEL, SEL))inherited)(self, _cmd, sel) : nil;
    if (signature || !TRCompatIsKnownFamily(sel)) {
        return signature;
    }
    BOOL isInstance = !class_isMetaClass(cls);
    Protocol *protocol = isInstance ? @protocol(TRCompatModelInitializers) : @protocol(TRCompatModelFactories);
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, isInstance);
    if (description.types && TRCompatReplacementSelector(cls, sel)) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    }
    return nil;
}

static void TRCompat_forwardInvocation(id self, SEL _cmd, NSInvocation *invocation) {
    Class cls = object_getClass(self);
    SEL missing = [invocation selector];
    SEL replacement = TRCompatIsKnownFamily(missing) ? TRCompatReplacementSelector(cls, missing) : NULL;
    if (!replacement) {
        IMP inherited = TRCompatInheritedIMP(gTRInheritedForwardIMPs, cls);
        if (inherited) {
            ((void (*)(id, SEL, NSInvocation *))inherited)(self, _cmd, invocation);
        } else {
            [self doesNotRecognizeSelector:missing];
        }
        return;
    }

    NSMethodSignature *sourceSignature = [invocation methodSignature];
    Method targetMethod = class_isMetaClass(cls) ? class_getClassMethod(self, replacement) : class_getInstanceMethod(cls, replacement);
    NSMethodSignature *targetSignature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(targetMethod)];
    NSInvocation *forwarded = [NSInvocation invocationWithMethodSignature:targetSignature];
    [forwarded setTarget:self];
    [forwarded setSelector:replacement];

    NSArray *sourceKeywords = TRCompatKeywords(missing, NULL);
    NSArray *targetKeywords = TRCompatKeywords(replacement, NULL);
    NSMutableArray *dropped = [NSMutableArray array];
    for (NSUInteger t = 0; t < [targetKeywords count]; t++) {
        NSUInteger targetIndex = t + 2;
        const char *targetType = TRCompatBareType([targetSignature getArgumentTypeAtIndex:targetIndex]);
        NSUInteger targetSize = 0;
        NSGetSizeAndAlignment(targetType, &targetSize, NULL);
        void *targetBuffer = calloc(1, targetSize > 16 ? targetSize : 16);

        NSUInteger s = [sourceKeywords indexOfObject:[targetKeywords objectAtIndex:t]];
        if (s != NSNotFound) {
            NSUInteger sourceIndex = s + 2;
            const char *sourceType = TRCompatBareType([sourceSignature getArgumentTypeAtIndex:sourceIndex]);
            NSUInteger sourceSize = 0;
            NSGetSizeAndAlignment(sourceType, &sourceSize, NULL);
            void *sourceBuffer = calloc(1, sourceSize > 16 ? sourceSize : 16);
            [invocation getArgument:sourceBuffer atIndex:sourceIndex];
            if (sourceType[0] == targetType[0] && sourceSize == targetSize) {
                memcpy(targetBuffer, sourceBuffer, targetSize);
            } else if (TRCompatIsNumeric(sourceType) && TRCompatIsNumeric(targetType)) {
                BOOL real = (sourceType[0] == 'f' || sourceType[0] == 'd');
                double realValue = sourceType[0] == 'f' ? *(float *)sourceBuffer : (sourceType[0] == 'd' ? *(double *)sourceBuffer : 0);
                TRCompatWriteNumber(targetType, targetBuffer, TRCompatReadInteger(sourceType, sourceBuffer), realValue, real);
            }
            // object <-> number mismatches stay 0/nil
            free(sourceBuffer);
        }
        [forwarded setArgument:targetBuffer atIndex:targetIndex];
        free(targetBuffer);
    }
    for (NSString *keyword in sourceKeywords) {
        if (![targetKeywords containsObject:keyword]) [dropped addObject:keyword];
    }

    NSString *logKey = [NSString stringWithFormat:@"%@ %@", TRCompatKey(cls), NSStringFromSelector(missing)];
    if (![gTRLoggedRemaps containsObject:logKey]) {
        [gTRLoggedRemaps addObject:logKey];
        NSLog(@"[TubeFixLegacy] YouTube %@: %@ has no -%@, using -%@ (dropped: %@)", version(), NSStringFromClass(class_isMetaClass(cls) ? self : cls), NSStringFromSelector(missing), NSStringFromSelector(replacement), [dropped componentsJoinedByString:@", "]);
    }

    [forwarded invoke];
    if ([sourceSignature methodReturnLength] > 0 && [targetSignature methodReturnLength] == [sourceSignature methodReturnLength]) {
        void *returnBuffer = calloc(1, [targetSignature methodReturnLength]);
        [forwarded getReturnValue:returnBuffer];
        [invocation setReturnValue:returnBuffer];
        free(returnBuffer);
    }
}

static void TRCompatPatchClass(Class cls) {
    if (!cls) return;
    SEL signatureSelector = @selector(methodSignatureForSelector:);
    SEL forwardSelector = @selector(forwardInvocation:);
    IMP inheritedSignature = class_getMethodImplementation(cls, signatureSelector);
    IMP inheritedForward = class_getMethodImplementation(cls, forwardSelector);
    Method signatureMethod = class_getInstanceMethod(cls, signatureSelector);
    Method forwardMethod = class_getInstanceMethod(cls, forwardSelector);
    if (!signatureMethod || !forwardMethod) return;
    // class_addMethod refuses when the class implements these itself;
    // then leave it alone
    if (class_addMethod(cls, signatureSelector, (IMP)TRCompat_methodSignatureForSelector, method_getTypeEncoding(signatureMethod))) {
        [gTRInheritedSignatureIMPs setObject:[NSValue valueWithPointer:(void *)inheritedSignature] forKey:TRCompatKey(cls)];
        if (class_addMethod(cls, forwardSelector, (IMP)TRCompat_forwardInvocation, method_getTypeEncoding(forwardMethod))) {
            [gTRInheritedForwardIMPs setObject:[NSValue valueWithPointer:(void *)inheritedForward] forKey:TRCompatKey(cls)];
        }
    }
}

__attribute__((constructor)) static void TRSelectorCompatInit(void) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!TRShouldLoadGoogleHooks() || TRIsVerifiedGoogleVersion(version())) {
        [pool release];
        return;
    }
    gTRInheritedSignatureIMPs = [[NSMutableDictionary alloc] init];
    gTRInheritedForwardIMPs = [[NSMutableDictionary alloc] init];
    gTRLoggedRemaps = [[NSMutableSet alloc] init];
    NSArray *models = [NSArray arrayWithObjects:@"YTVideo", @"YTChannel", @"YTPlaylist", @"YTEvent", @"YTPage", @"YTSubscription", @"YTUserProfile", @"YTSubtitlesTrack", @"YTComment", @"YTVideoState", @"YTCategory", @"YTCache", nil];
    for (NSString *name in models) {
        TRCompatPatchClass(NSClassFromString(name));
    }
    // +streamWithURL:... live on the metaclass
    Class stream = NSClassFromString(@"YTStream");
    if (stream) {
        TRCompatPatchClass(object_getClass(stream));
    }
    NSLog(@"[TubeFixLegacy] YouTube %@ isn't one of the verified versions; model initializer fallback is on", version());
    [pool release];
}
