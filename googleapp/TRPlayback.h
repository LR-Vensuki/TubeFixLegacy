// TRPlayback.h
// TubeFixLegacy
//
// Small playback helpers shared by double-tap seek (doubletapseek.x) and
// background playback / lock screen controls (playback.x). They talk to
// whatever player objects this app version has and fall back to the
// AVPlayer underneath when a version doesn't have the expected classes:
//
//   1.0.x        YTPlayerController     + YTPlayer_iOS5 (AVPlayer in avPlayer_)
//   1.1.0-1.3.0  YTPlayerController     + YTPlayer      (AVPlayer in player_/_player)
//   1.4.0        YTPlayerController     + MLPlayer      (AVPlayer in _player)
//   2.x          YTPlayerViewController + MLPlayer

#import <UIKit/UIKit.h>

// The controller that most recently started playing (not retained -
// cleared again when it goes away).
void TRSetActivePlayerController(id controller);
void TRClearActivePlayerController(id controller);
id TRActivePlayerController(void);

// The controller driving a YTPlayerView (its playerViewDelegate).
id TRPlayerControllerForPlayerView(UIView *playerView);

// The YTPlayer_iOS5 / YTPlayer / MLPlayer a controller plays through.
id TRPlayerOfController(id controller);

// Seeks by delta seconds, clamped to the video. controller may be nil,
// view is only used to find an AVPlayer when there's no controller.
BOOL TRSeekPlaybackBy(id controller, UIView *view, double delta);

// Play / pause / state / times through the controller when possible.
BOOL TRPlaybackIsPlaying(id controller);
BOOL TRPlaybackPlay(id controller);
BOOL TRPlaybackPause(id controller);
double TRPlaybackCurrentTime(id controller);
double TRPlaybackDuration(id controller);

// Every AVPlayer currently attached to an AVPlayerLayer on screen
// (below view, or in all windows when view is nil).
NSArray *TRVisibleAVPlayers(UIView *view);
