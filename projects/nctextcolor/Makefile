include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NCTextColor
NCTextColor_FILES = Tweak.xm
NCTextColor_FRAMEWORKS = UIKit Foundation
NCTextColor_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nctextcolorsettings
include $(THEOS_MAKE_PATH)/aggregate.mk
