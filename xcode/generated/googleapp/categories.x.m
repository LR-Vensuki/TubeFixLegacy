#line 1 "googleapp/categories.x"
#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "general.h"
#include "TRShorts.h"






@interface YTCategory : NSObject
{
    NSString *term_;
    NSString *label_;
    NSSet *browsableCountries_;
}

- (id)browsableCountries;
- (id)label;
- (id)term;
- (id)copyWithZone:(struct _NSZone *)fp8;
- (void)dealloc;
- (id)initWithTerm:(id)fp8 label:(id)fp12 browsableCountries:(id)fp16;

@end



@protocol TFLGuideEntryMessages
- (id)category;
- (NSString *)term;
@end

@interface YTGuideFeedController (TFL)
-(void)addCategories;
-(void)addCategoryTerm:(NSString*)term defaultLabel:(NSString*)defaultLabel toArray:(NSMutableArray*)categories enabledByDefault:(BOOL)enabledByDefault;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"");

@class YTGuideCell_iPhone; @class YTGDataRequest; @class YTGuideFeedController; @class GIPResourceLoader; @class YTResources; @class YTSubscription; @class YTCategory; 
static void _logos_method$_ungrouped$YTGuideFeedController$addCategoryTerm$defaultLabel$toArray$enabledByDefault$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, NSString*, NSString*, NSMutableArray*, BOOL); static void _logos_method$_ungrouped$YTGuideFeedController$addCategories(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$YTGuideFeedController$updateViews$)(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTGuideFeedController$updateViews$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$YTGuideFeedController$handleEntries$)(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, NSArray*); static void _logos_method$_ungrouped$YTGuideFeedController$handleEntries$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, NSArray*); static void (*_logos_orig$_ungrouped$YTGuideFeedController$authenticationDidChangeWithAuth$)(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTGuideFeedController$authenticationDidChangeWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$YTGuideCell_iPhone$setEntry$)(_LOGOS_SELF_TYPE_NORMAL YTGuideCell_iPhone* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$YTGuideCell_iPhone$setEntry$(_LOGOS_SELF_TYPE_NORMAL YTGuideCell_iPhone* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_meta_orig$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static id _logos_meta_method$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static id (*_logos_orig$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$)(_LOGOS_SELF_TYPE_NORMAL GIPResourceLoader* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static id _logos_method$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$(_LOGOS_SELF_TYPE_NORMAL GIPResourceLoader* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTSubscription(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTSubscription"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTCategory(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTCategory"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTResources(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTResources"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$YTGDataRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("YTGDataRequest"); } return _klass; }
#line 39 "googleapp/categories.x"



static void _logos_method$_ungrouped$YTGuideFeedController$addCategoryTerm$defaultLabel$toArray$enabledByDefault$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* term, NSString* defaultLabel, NSMutableArray* categories, BOOL enabledByDefault) {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
	NSArray *browsableCountries = TRGuideBrowsableCountries();
	if (![preferences[[NSString stringWithFormat:@"%@BrowseId", term]] isEqualToString:@""] && (enabledByDefault || preferences[[NSString stringWithFormat:@"%@BrowseId", term]])) {
		if (preferences[[NSString stringWithFormat:@"%@Name", term]]) {
			if (!([preferences[[NSString stringWithFormat:@"%@Name", term]] isEqualToString:@""])) {
						[categories addObject:[[[_logos_static_class_lookup$YTCategory() alloc] initWithTerm:term label:preferences[[NSString stringWithFormat:@"%@Name", term]] browsableCountries:browsableCountries] autorelease]];
			}
		} else {
			[categories addObject:[[[_logos_static_class_lookup$YTCategory() alloc] initWithTerm:term label:defaultLabel browsableCountries:browsableCountries] autorelease]];
		}
	}
}


static void _logos_method$_ungrouped$YTGuideFeedController$addCategories(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSMutableArray *categories = [NSMutableArray array];

	
	
	
	
	
	if (TRShortsEnabled()) {
		[categories addObject:[[[_logos_static_class_lookup$YTCategory() alloc] initWithTerm:TR_SHORTS_CATEGORY_TERM label:@"Shorts" browsableCountries:TRGuideBrowsableCountries()] autorelease]];
	}

	
	[self addCategoryTerm:@"Film"          defaultLabel:@"Film & Animation"      toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Autos"         defaultLabel:@"Autos & Vehicles"      toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Music"         defaultLabel:@"Music"                 toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Animals"       defaultLabel:@"Pets & Animals"        toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Sports"        defaultLabel:@"Sports"                toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Travel"        defaultLabel:@"Travel"                toArray:categories enabledByDefault:NO];
	[self addCategoryTerm:@"Games"         defaultLabel:@"Gaming"                toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Comedy"        defaultLabel:@"Comedy"                toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"People"        defaultLabel:@"People & Blogs"        toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"News"          defaultLabel:@"News & Politics"       toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Entertainment" defaultLabel:@"Entertainment"         toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Education"     defaultLabel:@"Education"             toArray:categories enabledByDefault:NO];
	[self addCategoryTerm:@"Howto"         defaultLabel:@"Howto & Style"         toArray:categories enabledByDefault:YES];
	[self addCategoryTerm:@"Nonprofit"     defaultLabel:@"Nonprofits & Activism" toArray:categories enabledByDefault:NO];
	[self addCategoryTerm:@"Tech"          defaultLabel:@"Science & Technology"  toArray:categories enabledByDefault:YES];

	[self handleEntries:categories];
	TFLLog(@"guide: %u categories (Shorts %d), categoriesCount %@, entryCount %d", (unsigned)[categories count], TRShortsEnabled(), [self valueForKey:l(@"categoriesCount")], [self entryCount]);
}


static void _logos_method$_ungrouped$YTGuideFeedController$updateViews$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id a3) {
	

	YTUserAuthenticator *userAuthenticator = nil;
	if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
		YTServices *services = [self valueForKey:l(@"services")];
		userAuthenticator = [services userAuthenticator];
	} else {
		userAuthenticator = [self valueForKey:l(@"userAuthenticator")];
	}
	

	
	id authentication = [userAuthenticator authentication];
	
	

	
	
	[self reset];
	if ( authentication )
	{
		[self loadAccountThumbnail];

		if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
			YTGDataRequest *requestSubscriptions = [_logos_static_class_lookup$YTGDataRequest() requestForMySubscriptionsWithAuth:authentication];
			[self makeRequest:requestSubscriptions serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:)]; 
		} else {
			
			id requestSubscriptions = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestForMySubscriptionsWithAuth:authentication];
			[self makeRequest:requestSubscriptions serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:)]; 
		}
		
	} else {
		[self addCategories];
	}
	
	
	
	

	
	

	
}


static void _logos_method$_ungrouped$YTGuideFeedController$handleEntries$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSArray* entries) {
	_logos_orig$_ungrouped$YTGuideFeedController$handleEntries$(self, _cmd, entries);
	if ([entries count] == 0) { 
		[self addCategories];
		return;
	}

	if ([entries[0] isKindOfClass:[_logos_static_class_lookup$YTSubscription() class]]) {
		[self addCategories];
	}
}



static void _logos_method$_ungrouped$YTGuideFeedController$authenticationDidChangeWithAuth$(_LOGOS_SELF_TYPE_NORMAL YTGuideFeedController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id authentication) {
	[self setValue:@(authentication != nil) forKey:@"_isAuthenticated"];
	[self setValue:@([(NSNumber*)[self valueForKey:@"_authenticationChangedCount"] intValue]+1) forKey:@"_authenticationChangedCount"];

	if ([[self valueForKey:@"_isAuthenticated"] intValue] == 1)
	{
		YTGDataRequestFactory *GDataRequestFactory = [self valueForKey:@"_GDataRequestFactory"];
		id guideTableView = [(YTGuideTableView*)[self valueForKey:@"_guideTableView"] cellForAccount];
		[self updateAccountCell:guideTableView];
		YTGuideEntry *accountEntry = [self valueForKey:@"_accountEntry"];
		NSString *accessibilityText = localizedStringForKey(@"guide.account_loggedin.access");
		[accountEntry setAccessibilityLabel:accessibilityText];
		id subscriptionsRequest = [GDataRequestFactory requestForMySubscriptionsWithAuth:authentication];
		[self makeRequest:subscriptionsRequest serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:)];
	} else {
		[self addCategories];
	}
}








static void _logos_method$_ungrouped$YTGuideCell_iPhone$setEntry$(_LOGOS_SELF_TYPE_NORMAL YTGuideCell_iPhone* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id entry) {
    _logos_orig$_ungrouped$YTGuideCell_iPhone$setEntry$(self, _cmd, entry);
    id category = [entry respondsToSelector:@selector(category)] ? [(id<TFLGuideEntryMessages>)entry category] : nil;
    if ([category respondsToSelector:@selector(term)] && TRIsShortsCategoryTerm([(id<TFLGuideEntryMessages>)category term])) {
        [self setThumbnail:TRLoadImage(@"guide_shorts") animated:NO];
    }
}







@interface YTResources : NSObject
+ (id)guidePopularImageWithSelected:(BOOL)selected;
@end

static UIImage *TRShortsGuideIcon(BOOL selected) {
    UIImage *image = TRLoadImage(selected ? @"guide_shorts_selected" : @"guide_shorts");
    if (!image && [_logos_static_class_lookup$YTResources() respondsToSelector:@selector(guidePopularImageWithSelected:)]) {
        image = [_logos_static_class_lookup$YTResources() guidePopularImageWithSelected:selected];
    }
    return image;
}




static id _logos_meta_method$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * term, BOOL selected) {
    if (TRIsShortsCategoryTerm(term)) {
        UIImage *image = TRShortsGuideIcon(selected);
        TFLLog(@"Shorts guide icon (selected %d): %@", selected, image);
        if (image) {
            return image;
        }
    }
    return _logos_meta_orig$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$(self, _cmd, term, selected);
}






static id _logos_method$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$(_LOGOS_SELF_TYPE_NORMAL GIPResourceLoader* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * term, BOOL selected) {
    if (TRIsShortsCategoryTerm(term)) {
        UIImage *image = TRShortsGuideIcon(selected);
        if (image) {
            return image;
        }
    }
    return _logos_orig$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$(self, _cmd, term, selected);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTGuideFeedController = objc_getClass("YTGuideFeedController"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); memcpy(_typeEncoding + i, @encode(NSMutableArray*), strlen(@encode(NSMutableArray*))); i += strlen(@encode(NSMutableArray*)); memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTGuideFeedController, @selector(addCategoryTerm:defaultLabel:toArray:enabledByDefault:), (IMP)&_logos_method$_ungrouped$YTGuideFeedController$addCategoryTerm$defaultLabel$toArray$enabledByDefault$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTGuideFeedController, @selector(addCategories), (IMP)&_logos_method$_ungrouped$YTGuideFeedController$addCategories, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$YTGuideFeedController, @selector(updateViews:), (IMP)&_logos_method$_ungrouped$YTGuideFeedController$updateViews$, (IMP*)&_logos_orig$_ungrouped$YTGuideFeedController$updateViews$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGuideFeedController, @selector(handleEntries:), (IMP)&_logos_method$_ungrouped$YTGuideFeedController$handleEntries$, (IMP*)&_logos_orig$_ungrouped$YTGuideFeedController$handleEntries$);}{ MSHookMessageEx(_logos_class$_ungrouped$YTGuideFeedController, @selector(authenticationDidChangeWithAuth:), (IMP)&_logos_method$_ungrouped$YTGuideFeedController$authenticationDidChangeWithAuth$, (IMP*)&_logos_orig$_ungrouped$YTGuideFeedController$authenticationDidChangeWithAuth$);}Class _logos_class$_ungrouped$YTGuideCell_iPhone = objc_getClass("YTGuideCell_iPhone"); { MSHookMessageEx(_logos_class$_ungrouped$YTGuideCell_iPhone, @selector(setEntry:), (IMP)&_logos_method$_ungrouped$YTGuideCell_iPhone$setEntry$, (IMP*)&_logos_orig$_ungrouped$YTGuideCell_iPhone$setEntry$);}Class _logos_class$_ungrouped$YTResources = objc_getClass("YTResources"); Class _logos_metaclass$_ungrouped$YTResources = object_getClass(_logos_class$_ungrouped$YTResources); { MSHookMessageEx(_logos_metaclass$_ungrouped$YTResources, @selector(categoryThumbnailWithTerm:selected:), (IMP)&_logos_meta_method$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$, (IMP*)&_logos_meta_orig$_ungrouped$YTResources$categoryThumbnailWithTerm$selected$);}Class _logos_class$_ungrouped$GIPResourceLoader = objc_getClass("GIPResourceLoader"); { MSHookMessageEx(_logos_class$_ungrouped$GIPResourceLoader, @selector(categoryThumbnailWithTerm:selected:), (IMP)&_logos_method$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$, (IMP*)&_logos_orig$_ungrouped$GIPResourceLoader$categoryThumbnailWithTerm$selected$);}} }
#line 235 "googleapp/categories.x"
