include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EzSwitch
EzSwitch_FILES = Tweak.xm
EzSwitch_Frameworks = UIKit
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ezswitchprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
