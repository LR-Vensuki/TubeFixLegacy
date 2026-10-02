// TRPlayerRequest.h
// TubeFixLegacy
//
// The InnerTube /player request (stream URLs for one video) exactly as
// -[YTGDataService makeVideoRequestWithVideoID:...] sends it: the client
// chosen under "Video Quality" -> "Stream", plus PO token and signature
// timestamp where that client needs them. Implemented in getvideo.x.

#import <Foundation/Foundation.h>

NSURL *TRPlayerRequestURL(void);

// May block for a moment while the PO token is minted - call it off the
// main thread when you can.
NSData *TRPlayerRequestBody(NSString *videoId);
