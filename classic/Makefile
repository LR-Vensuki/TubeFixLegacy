TARGET := iphone:clang:6.1:5.0
# iOS 5+ only runs on armv7 (and later arm64) hardware
ARCHS := armv7 armv7s

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TubeFixLegacyClassic

TubeFixLegacyClassic_FILES = classic.x
TubeFixLegacyClassic_FRAMEWORKS = UIKit MediaPlayer AVFoundation
TubeFixLegacyClassic_CFLAGS = -fno-objc-arc -include $(THEOS_PROJECT_DIR)/common/TFLCompat.h

include $(THEOS_MAKE_PATH)/tweak.mk
