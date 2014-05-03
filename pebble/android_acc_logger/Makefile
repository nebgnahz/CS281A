.default: all

all: android_start

android_build:
	ant debug

android_install: android_build
	adb install -r bin/AccLogger-debug.apk

android_start: android_install
	adb shell am start -n edu.berkeley.eecs.acclogger/.AccLoggerActivity

clean:
	ant clean


