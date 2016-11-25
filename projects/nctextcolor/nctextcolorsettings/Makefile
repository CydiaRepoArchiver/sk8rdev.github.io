include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = nctextcolorsettings
nctextcolorsettings_FILES = NCTextColorRootListController.m
nctextcolorsettings_INSTALL_PATH = /Library/PreferenceBundles
nctextcolorsettings_FRAMEWORKS = UIKit CoreGraphics
nctextcolorsettings_PRIVATE_FRAMEWORKS = Preferences
nctextcolorsettings_LIBRARIES = colorpicker


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nctextcolorsettings.plist$(ECHO_END)
