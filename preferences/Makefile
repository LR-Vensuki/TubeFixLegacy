TARGET := iphone:clang:6.1:5.0
INSTALL_TARGET_PROCESSES = Preferences
ARCHS := armv7 armv7s

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TubeFixLegacyPrefs
LIB_DIR = $(THEOS_PROJECT_DIR)/lib

TubeFixLegacyPrefs_FILES = YTRPRootListController.m TFLLanguage.m YTRPDebugListController.m YTRPQualitySelectorListController.m $(LIB_DIR)/zip/src/zip.c
TubeFixLegacyPrefs_FRAMEWORKS = UIKit MessageUI
TubeFixLegacyPrefs_PRIVATE_FRAMEWORKS = Preferences
TubeFixLegacyPrefs_INSTALL_PATH = /Library/PreferenceBundles
TubeFixLegacyPrefs_CFLAGS = -fobjc-arc -include $(THEOS_PROJECT_DIR)/common/TFLCompat.h -DZIP_HAVE_SYMLINK=1 # todo: figure out how to remove arc stuff

include $(THEOS_MAKE_PATH)/bundle.mk
