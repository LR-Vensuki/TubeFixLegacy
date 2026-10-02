TARGET := iphone:clang:6.1:5.0
# INSTALL_TARGET_PROCESSES = YouTube
ARCHS := armv7 armv7s

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TubeFixLegacy

GOOGLE_APP = 1

TubeFixLegacy_FRAMEWORKS += UIKit CoreGraphics QuartzCore MediaPlayer AVFoundation CoreMedia CFNetwork Security


GOOGLE_APP_FILES = $(THEOS_PROJECT_DIR)/googleapp
COMMON = $(THEOS_PROJECT_DIR)/common
LIB_DIR = $(THEOS_PROJECT_DIR)/lib
COMMON_GOOGLE = $(THEOS_PROJECT_DIR)/common-google

TubeFixLegacy_FILES = TRHookGate.m \
	TRSelectorCompat.m \
	polyfill.x \
	signin.x \
	deviceauth.x \
	frontfeed.x \
	parsing.x \
	categories.x \
	getvideo.x \
	handlevideo.x \
	channels.x \
	channelfeed.x \
	search.x \
	feeds.x \
	myprofile.x \
	subscriptions.x \
	homefeed.x \
	suggestedvideos.x \
	comments.x \
	accountfeeds.x \
	playlist.x \
	likes.x \
	general.x \
	network.x \
	settings.x \
	subtitles.x \
	crashreporter.x \
	infooverflowfix.x \
	videostats.x \
	migration.x \
	doubletapseek.x \
	pinchfill.x \
	TRSeekIndicatorView.m \
	playback.x \
	TRShorts.m \
	TRShortsPlayer.m \
	shortsplayer.x \
	$(COMMON)/potoken.m \
	$(COMMON_GOOGLE)/potoken-google.m \
	$(shell find $(COMMON)/SABR -type f -name '*.m') \
	Translators/TRJSONUtils.m \
	Translators/TRJSONTranslator.m \
	Translators/TRContiunation.m \
	Translators/Delegates/TRVideoTranslator.m \
	Translators/Delegates/TRChannelTranslator.m \
	Translators/Delegates/TRFeedTranslator.m \
	Translators/Delegates/TRCommentTranslator.m \
	Translators/Delegates/TRSubscriptionTranslator.m \
	Translators/Delegates/TRPlaylistTranslator.m \
	Translators/TRRequestBuilder.m \
	$(LIB_DIR)/protobuf/GPBProtocolBuffers.m \
	$(shell find $(COMMON)/SABR/proto/generated -type f -name '*.m') \
	$(shell find $(LIB_DIR)/cocoahttpserver -type f -name '*.m') \
	$(COMMON)/Protobuf.m $(COMMON)/YoutubeClientType.m general.m ../base64/NSData+Base64.m ../base64/NSString+Base64.m
	
# GOOGLE_APP: signin.x has code paths that differ from the capture app
# MSHookMessageEx: every hook goes through TRGatedHookMessageEx
# (TRHookGate.m), which skips them on YouTube versions TubeFixLegacy
# doesn't support so the legacy fallback can take those over
TubeFixLegacy_CFLAGS = -fno-objc-arc -include $(THEOS_PROJECT_DIR)/common/TFLCompat.h -ITranslators -DGOOGLE_APP=1 -DMSHookMessageEx=TRGatedHookMessageEx
# TubeFixLegacy_LDFLAGS = ../lib/libtree-sitter.a
# TubeFixLegacy_LDFLAGS = ../lib/libposixshim.a
TubeFixLegacy_OBJCFLAGS += -I$(LIB_DIR)/protobuf
TubeFixLegacy_OBJCFLAGS += -I$(THEOS_PROJECT_DIR)/common/SABR/proto/generated

before-all::
	rm signinpolyfil.h || true
	xxd -i signinpolyfil.js > signinpolyfil.h

ifeq (, $(shell which xxd))
$(error "You are missing `xxd` from your system, which is required to build.")
endif

include $(THEOS_MAKE_PATH)/tweak.mk
