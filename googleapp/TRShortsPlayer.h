// TRShortsPlayer.h
// TubeFixLegacy
//
// A full-screen, vertically swiped Shorts player in the spirit of the
// real one: each Short fills the screen and loops, swiping up/down moves
// to the next/previous one (the Shorts that came with the tapped one in
// its feed first, then more from the Shorts search), tap pauses, double
// tap likes. Streams come from the same InnerTube /player request and
// translator as the app's own player (HLS, SABR and progressive all
// work), so the "Stream" setting applies here too.

#import <UIKit/UIKit.h>

// Opens the player on videoID. openInRegularPlayer is called (after the
// Shorts player went away) when the person asks for the app's own watch
// page for some Short - with that Short's ID. Returns NO if the player
// couldn't be shown (then show the regular watch page instead).
BOOL TRPresentShortsPlayer(NSString *videoID, void (^openInRegularPlayer)(NSString *videoID));

// Same, starting at sequence[index] (dictionaries as in TRShorts.h) - for
// the Shorts row, which isn't a feed the registry knows about.
// openInRegularPlayer may be nil.
BOOL TRPresentShortsPlayerWithSequence(NSArray *sequence, NSUInteger index, void (^openInRegularPlayer)(NSString *videoID));

// YES while the Shorts player is on screen.
BOOL TRShortsPlayerIsVisible(void);
