#import <Foundation/Foundation.h>
#include <spawn.h>
#include <sys/wait.h>
#import <Preferences/PSSpecifier.h>
#import "YTRPRootListController.h"
#import "../common/TRVersionSupport.h"
#import "TFLLanguage.h"

#define NOTIFY_NAME CFSTR("com.legacyreborn.tubefixlegacy/settingschanged")

static void TFLPostSettingsChanged(void) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), NOTIFY_NAME, NULL, NULL, YES);
}

// Both apps (Google's YouTube and YouTube Classic) have the executable name "YouTube".
static void TFLKillYouTube(void) {
    pid_t pid;
    char *argv[] = { "killall", "-9", "YouTube", NULL };
    if (posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, argv, NULL) == 0) {
        waitpid(pid, NULL, 0);
    }
}

@implementation YTRPRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        // settings carried over from TubeReplacer on first open
        TRMigrateOldPreferences();
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)killYouTube {
    TFLKillYouTube();
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    if ([[specifier.properties objectForKey:@"key"] isEqualToString:@"Language"]) {
        // redraw this page in the new language (sub-pages pick it up when opened)
        TFLLanguageDidChange();
        _specifiers = nil;
        [self reloadSpecifiers];
    }
}

@end

@implementation TFLVideoListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *specs = [[self loadSpecifiersFromPlistName:@"Video" target:self] mutableCopy];
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
        NSString *stream = [prefs objectForKey:@"StreamType"] ?: @"web";
        if (![stream isEqualToString:@"custom"]) {
            // the custom URL field only matters for "Custom URL"
            for (NSUInteger i = 0; i < [specs count]; i++) {
                PSSpecifier *spec = [specs objectAtIndex:i];
                if ([[spec.properties objectForKey:@"key"] isEqualToString:@"CustomStreamURL"]) {
                    [specs removeObjectAtIndex:i];
                    break;
                }
            }
        }
        _specifiers = specs;
    }
    return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    if ([[specifier.properties objectForKey:@"key"] isEqualToString:@"StreamType"]) {
        // the stream is picked when the app starts
        TFLKillYouTube();
        _specifiers = nil;
        [self reloadSpecifiers];
    }
}

@end

@implementation TFLCategoriesListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Categories" target:self];
    }
    return _specifiers;
}

// Removing the keys brings back the built-in defaults (the tweak and Categories.plist share them).
- (void)resetCategorySettings {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:TR_PREFS_PATH];
    if (!prefs) {
        return;
    }
    for (NSString *key in [prefs allKeys]) {
        if ([key hasSuffix:@"BrowseId"] || ([key hasSuffix:@"Name"] && ![key isEqualToString:@"Name"])) {
            [prefs removeObjectForKey:key];
        }
    }
    [prefs writeToFile:TR_PREFS_PATH atomically:YES];
    TFLPostSettingsChanged();
    _specifiers = nil;
    [self reloadSpecifiers];
}

@end

@implementation TFLAdvancedListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Advanced" target:self];
    }
    return _specifiers;
}

@end
