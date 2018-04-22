include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = EzSwitchPrefs
EzSwitchPrefs_FILES = CSPRootListController.m
EzSwitchPrefs_INSTALL_PATH = /Library/PreferenceBundles
EzSwitchPrefs_FRAMEWORKS = UIKit
EzSwitchPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/EzSwitchPrefs.plist$(ECHO_END)
