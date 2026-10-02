#include <Foundation/Foundation.h>
#include "appheaders.h"
#include "general.h"
#include "TRShorts.h"

// -[YTCategoryParser parseElement:error:]
// -[YTGuideFeedController handleEntries: is where categories are requested
//-[YTFeedController maybeMakeNextRequest]


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

// YTGuideEntry (the row's model) and YTCategory, as far as the Shorts
// icon below needs them
@protocol TFLGuideEntryMessages
- (id)category;
- (NSString *)term;
@end

@interface YTGuideFeedController (TFL)
-(void)addCategories;
-(void)addCategoryTerm:(NSString*)term defaultLabel:(NSString*)defaultLabel toArray:(NSMutableArray*)categories enabledByDefault:(BOOL)enabledByDefault;
@end

%hook YTGuideFeedController

%new
-(void)addCategoryTerm:(NSString*)term defaultLabel:(NSString*)defaultLabel toArray:(NSMutableArray*)categories enabledByDefault:(BOOL)enabledByDefault {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.legacyreborn.tubefixlegacy.plist"];
	NSArray *browsableCountries = TRGuideBrowsableCountries();
	if (![preferences[[NSString stringWithFormat:@"%@BrowseId", term]] isEqualToString:@""] && (enabledByDefault || preferences[[NSString stringWithFormat:@"%@BrowseId", term]])) {
		if (preferences[[NSString stringWithFormat:@"%@Name", term]]) {
			if (!([preferences[[NSString stringWithFormat:@"%@Name", term]] isEqualToString:@""])) {
						[categories addObject:[[[%c(YTCategory) alloc] initWithTerm:term label:preferences[[NSString stringWithFormat:@"%@Name", term]] browsableCountries:browsableCountries] autorelease]];
			}
		} else {
			[categories addObject:[[[%c(YTCategory) alloc] initWithTerm:term label:defaultLabel browsableCountries:browsableCountries] autorelease]];
		}
	}
}

%new
-(void)addCategories {
	NSMutableArray *categories = [NSMutableArray array];

	// Shorts goes in first, as a category like the ones below. The term
	// is a marker that never reaches the server - frontfeed.x turns it
	// into a Shorts-only search. It needs the same browsable countries
	// as every other category: the guide drops categories that aren't
	// browsable in the user's country, which is what hid it before.
	if (TRShortsEnabled()) {
		[categories addObject:[[[%c(YTCategory) alloc] initWithTerm:TR_SHORTS_CATEGORY_TERM label:@"Shorts" browsableCountries:TRGuideBrowsableCountries()] autorelease]];
	}

	// TODO: The category fetching relies on the language being set correctly to have them all be translated correctly, we should move this 
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

// handles subscriptions & categories
- (void)updateViews:(id)a3 {
	

	YTUserAuthenticator *userAuthenticator = nil;
	if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
		YTServices *services = [self valueForKey:l(@"services")];
		userAuthenticator = [services userAuthenticator];
	} else {
		userAuthenticator = [self valueForKey:l(@"userAuthenticator")];
	}
	

	// might be GTMOAuth2Authentication, but ID is probably more reliable
	id authentication = [userAuthenticator authentication];
	// NSString *userLang = [%c(YTUtils) userLanguageCode];
	// YTGDataRequest *requestCategories = [%c(YTGDataRequest) requestForCategoriesWithLanguageCode:userLang];

	
	// todo: fuck with -[YTFeedController refresh] and get it to actually finish refreshing.
	[self reset];
	if ( authentication )
	{
		[self loadAccountThumbnail];

		if ([version() isEqualToString:@"1.0.0"] || [version() isEqualToString:@"1.0.1"]) {
			YTGDataRequest *requestSubscriptions = [%c(YTGDataRequest) requestForMySubscriptionsWithAuth:authentication];
			[self makeRequest:requestSubscriptions serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:)]; // i'm hardcoding the categories so we shouldnt need them
		} else {
			// todo: [(YTGuideEntry*)[self valueForKey:l(@"accountEntry")] setAccessibilityLabel:localizedStringForKey(@"guide.account_loggedin.access")];
			id requestSubscriptions = [(YTGDataRequestFactory*)[self valueForKey:l(@"GDataRequestFactory")] requestForMySubscriptionsWithAuth:authentication];
			[self makeRequest:requestSubscriptions serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:)]; // i'm hardcoding the categories so we shouldnt need them
		}
		// [self makeRequest:requestSubscriptions serviceSelector:@selector(makeMySubscriptionsRequest:responseBlock:errorBlock:) extraRequest:requestCategories extraServiceSelector:@selector(makeCategoriesRequest:responseBlock:errorBlock:)];
	} else {
		[self addCategories];
	}
	// else
	// {
	// 	[self makeRequest:requestCategories serviceSelector:@selector(makeCategoriesRequest:responseBlock:errorBlock:)];
	// }

	// give hardcoded categories :3
	// NSLog(@"my country is %@", [%c(YTUtils) userCountryCode]);

	
}

-(void) handleEntries:(NSArray*)entries
{
	%orig;
	if ([entries count] == 0) { // todo: this may break if someone disables every single category, but why would you???
		[self addCategories];
		return;
	}

	if ([entries[0] isKindOfClass:[%c(YTSubscription) class]]) {
		[self addCategories];
	}
}

// 2.x
-(void)authenticationDidChangeWithAuth:(id)authentication
{
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
%end
// The Shorts row rides the same YTCategory path as Film/Music/etc (see
// addCategories above), so it ends up in a normal YTGuideCell_iPhone
// like any other category row - this just swaps in our own icon for
// that one specific entry instead of leaving it icon-less.
%hook YTGuideCell_iPhone

-(void)setEntry:(id)entry
{
    %orig;
    id category = [entry respondsToSelector:@selector(category)] ? [(id<TFLGuideEntryMessages>)entry category] : nil;
    if ([category respondsToSelector:@selector(term)] && TRIsShortsCategoryTerm([(id<TFLGuideEntryMessages>)category term])) {
        [self setThumbnail:TRLoadImage(@"guide_shorts") animated:NO];
    }
}

%end

// -[YTGuideFeedController handleEntries:] asks for the row icon by
// category term and *drops every category it gets no icon for* - that is
// what kept Shorts out of the guide. 1.1.0 / 1.2.1 ask GIPResourceLoader,
// 1.3.0 / 1.4.0 ask +[YTResources categoryThumbnailWithTerm:selected:].
@interface YTResources : NSObject
+ (id)guidePopularImageWithSelected:(BOOL)selected;
@end

static UIImage *TRShortsGuideIcon(BOOL selected) {
    UIImage *image = TRLoadImage(selected ? @"guide_shorts_selected" : @"guide_shorts");
    if (!image && [%c(YTResources) respondsToSelector:@selector(guidePopularImageWithSelected:)]) {
        image = [%c(YTResources) guidePopularImageWithSelected:selected];
    }
    return image;
}

%hook YTResources

+(id)categoryThumbnailWithTerm:(NSString *)term selected:(BOOL)selected
{
    if (TRIsShortsCategoryTerm(term)) {
        UIImage *image = TRShortsGuideIcon(selected);
        TFLLog(@"Shorts guide icon (selected %d): %@", selected, image);
        if (image) {
            return image;
        }
    }
    return %orig;
}

%end

%hook GIPResourceLoader

-(id)categoryThumbnailWithTerm:(NSString *)term selected:(BOOL)selected
{
    if (TRIsShortsCategoryTerm(term)) {
        UIImage *image = TRShortsGuideIcon(selected);
        if (image) {
            return image;
        }
    }
    return %orig;
}

%end
