// Minimal Preferences.framework declarations (iOS 5/6) for TubeFixLegacyPrefs.
#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSSpecifier.h>

@interface PSListController : PSViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_specifiers;
}
- (NSArray *)specifiers;
- (NSMutableArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
- (void)reloadSpecifiers;
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
- (id)readPreferenceValue:(PSSpecifier *)specifier;
@end
