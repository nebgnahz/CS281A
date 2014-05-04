.default: all

all: android_start

android_build:
	ant debug

android_install: android_build
	adb install -r bin/AccLogger-debug.apk

android_start: android_install
	adb shell am start -n edu.berkeley.eecs.acclogger/.AccLoggerActivity

sync: 
	adb pull /sdcard/logfile.csv ../../data
	sed 's/null//g' ../../data/logfile.csv > ../../data/logfile_cleaned.csv

android_clean:
	adb shell rm /sdcard/logfile.csv

clean:
	ant clean


