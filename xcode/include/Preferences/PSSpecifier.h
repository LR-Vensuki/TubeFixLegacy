// Minimal Preferences.framework declarations (iOS 5/6) for TubeFixLegacyPrefs.
#import <Foundation/Foundation.h>

@interface PSSpecifier : NSObject
@property (nonatomic, retain) NSMutableDictionary *properties;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id target;
- (id)propertyForKey:(NSString *)key;
- (void)setProperty:(id)property forKey:(NSString *)key;
@end
