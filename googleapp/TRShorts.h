// TRShorts.h
// TubeFixLegacy
//
// Shared bits for Shorts support.
//
// The side-menu "Shorts" entry (categories.x) is a normal YTCategory
// whose term is TR_SHORTS_CATEGORY_TERM. frontfeed.x turns a standard
// feed request for that term into an InnerTube search restricted to
// Shorts, and marks its continuation tokens with
// TR_SHORTS_CONTINUATION_PREFIX so the next pages go back to the search
// endpoint instead of browse.

#import <Foundation/Foundation.h>

#define TR_SHORTS_CATEGORY_TERM @"__TRShorts__"
#define TR_SHORTS_CONTINUATION_PREFIX @"__TRShorts__:"

// InnerTube search "type" filter value for Shorts (params EgIQCQ==)
#define TR_SHORTS_SEARCH_TYPE 9

BOOL TRIsShortsCategoryTerm(NSString *term);

// Same list of countries every other side-menu category uses - the
// guide hides categories that aren't browsable in the user's country.
NSArray *TRGuideBrowsableCountries(void);

// Post-processes a page of the Shorts feed: the continuation token gets
// TR_SHORTS_CONTINUATION_PREFIX so the next page is fetched from the
// search endpoint again (shelves are already expanded by the translator).
void TRShortsPreparePage(id page);

// YES for a feed item that is a Short in any of the shapes InnerTube
// currently sends (shortsLockupViewModel, reelItemRenderer, or a regular
// video renderer whose tap opens the Shorts player).
BOOL TRJSONItemIsShort(NSDictionary *item);

// If item is a shelf of Shorts, returns its raw items; otherwise nil.
NSArray *TRJSONShortsShelfItems(NSDictionary *item);

// Portrait (9:16) thumbnail of a Short, kept on the YTVideo for the
// horizontal shelf. Rows use the regular landscape thumbnails.
void TRSetShortsPortraitThumbnail(id video, NSURL *url);
NSURL *TRShortsPortraitThumbnail(id video);

// Keys of the dictionaries describing one Short (TRShortsSequenceAround,
// and what the Shorts player works with)
#define TR_SHORT_VIDEO_ID @"videoId"
#define TR_SHORT_TITLE @"title"
#define TR_SHORT_AUTHOR @"author"
#define TR_SHORT_CHANNEL_ID @"channelId"
#define TR_SHORT_VIEWS @"views"          // NSNumber
#define TR_SHORT_THUMBNAIL @"thumbnail"  // NSURL, portrait when known

// Called by the translator for every Short it turns into a YTVideo. Shorts
// translated in one go (one feed page) form a sequence the Shorts player
// can swipe through.
void TRRegisterShortVideo(id video, NSURL *portraitThumbnail);
BOOL TRVideoIsShort(id video);
BOOL TRIsKnownShortVideoID(NSString *videoID);

// The most recent sequence containing videoID (array of the dictionaries
// above), with *index set to videoID's position. nil if it was never seen.
NSArray *TRShortsSequenceAround(NSString *videoID, NSUInteger *index);

// Turns one Shorts item of an InnerTube response (any of the shapes
// TRJSONItemIsShort accepts) into the dictionary above; nil if it isn't one.
NSDictionary *TRShortInfoFromJSONItem(NSDictionary *item);

// Every Short anywhere in an InnerTube response, in order (as the
// dictionaries above), plus its continuation token. Walks the whole tree,
// since the wrappers around them change all the time.
void TRCollectShortsFromJSON(id json, NSMutableArray *shorts, NSString **continuation);

// The side-menu Shorts feed is only an entry point (a search for
// TRShortsQuery): a Short tapped there continues with YouTube's own Shorts
// recommendations in the player rather than with the rest of that search.
void TRMarkShortsCategoryPage(id page);
BOOL TRIsShortsCategoryVideoID(NSString *videoID);

