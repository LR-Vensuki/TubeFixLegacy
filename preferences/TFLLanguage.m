// TFLLanguage.m
// TubeFixLegacy
//
// The settings pane in the language picked under "Language" (Automatic
// follows iOS). PSListController translates every label, footer and title
// through -[NSBundle localizedStringForKey:value:table:] on this bundle,
// so that one method is redirected - for this bundle only. The plists are
// written in English and ru.lproj translates them, so "English" simply
// means the untranslated text.
//
// The tweak inside YouTube reads the same "Language" key (see
// TRTweakLanguageIsRussian in googleapp/general.m).

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "YTRPRootListController.h"
#import "TFLLanguage.h"
#import "../common/TRVersionSupport.h"

static NSString *gTFLBundlePath = nil;
static IMP gTFLOriginalLocalizedString = NULL;
static NSMutableDictionary *gTFLTables = nil;
static NSString *gTFLLanguage = nil;
static CFAbsoluteTime gTFLLanguageReadAt = 0;

// read at most every half second - every label on a page asks
NSString *TFLChosenLanguage(void) {
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (!gTFLLanguage || now - gTFLLanguageReadAt > 0.5) {
        NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
        NSString *language = [preferences objectForKey:@"Language"];
        gTFLLanguage = [language isKindOfClass:[NSString class]] ? language : @"auto";
        gTFLLanguageReadAt = now;
    }
    return gTFLLanguage;
}

void TFLLanguageDidChange(void) {
    gTFLLanguage = nil;
}

static NSString *TFLLocalizedString(NSBundle *self, SEL _cmd, NSString *key, NSString *value, NSString *table) {
    NSString *(*original)(id, SEL, NSString *, NSString *, NSString *) = (NSString *(*)(id, SEL, NSString *, NSString *, NSString *))gTFLOriginalLocalizedString;
    if (key && gTFLBundlePath && [[self bundlePath] isEqualToString:gTFLBundlePath]) {
        NSString *language = TFLChosenLanguage();
        if ([language isEqualToString:@"en"]) {
            return [value length] ? value : key;
        }
        if ([language isEqualToString:@"ru"]) {
            NSString *name = [table length] ? table : @"Localizable";
            NSDictionary *strings = [gTFLTables objectForKey:name];
            if (!strings) {
                NSString *path = [gTFLBundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"ru.lproj/%@.strings", name]];
                strings = [NSDictionary dictionaryWithContentsOfFile:path] ?: [NSDictionary dictionary];
                [gTFLTables setObject:strings forKey:name];
            }
            NSString *translated = [strings objectForKey:key];
            if (translated) {
                return translated;
            }
            return [value length] ? value : key;
        }
    }
    return original(self, _cmd, key, value, table);
}

__attribute__((constructor)) static void TFLLanguageInit(void) {
    @autoreleasepool {
        gTFLBundlePath = [[[NSBundle bundleForClass:[YTRPRootListController class]] bundlePath] copy];
        gTFLTables = [NSMutableDictionary dictionary];
        Method method = class_getInstanceMethod([NSBundle class], @selector(localizedStringForKey:value:table:));
        if (method) {
            gTFLOriginalLocalizedString = method_setImplementation(method, (IMP)TFLLocalizedString);
        }
    }
}
