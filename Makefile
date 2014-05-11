PAPER_DIR = doc/paper
# CODE_DIR = doc/paper

.PHONY: paper

paper_generate:
	$(MAKE) -C $(PAPER_DIR) open

paper_clean:
	$(MAKE) -C $(PAPER_DIR) clean
## 	$(MAKE) -C $(CODE_DIR) clean


## Android related
android: android_start

android_build:
	cd pebble/android_acc_logger && ant debug

android_install: android_build
	cd pebble/android_acc_logger && adb install -r bin/AccLogger-debug.apk

android_start: android_install
	adb shell am start -n edu.berkeley.eecs.acclogger/.AccLoggerActivity

android_sync: 
	adb pull /sdcard/logfile.csv data/
	sed 's/null//g' data/logfile.csv > data/logfile_cleaned.csv

android_data_clean:
	adb shell rm /sdcard/logfile.csv

android_clean:
	cd pebble/android_acc_logger && ant clean


## Pebble related 

pebble_build:
	cd pebble/pebble_acc_logger && pebble build

pebble_install: pebble_build
	cd pebble/pebble_acc_logger && pebble install --phone 128.32.45.171

## galaxy server related

server_run:
	cd /home/cs281/data && python -m SimpleHTTPServer

server_export:
	mongoexport --host localhost --db bearloc --collection data --csv --out text.csv --fields type,id,eventnano,sysnano,epoch,x,y,z,xr,yr,zr

server_stat:
	$(info counting number of records in bearloc ) 
	mongo bearloc --eval "db.data.count()"

server_last:
	mongo bearloc --eval "db.data.find({id:'276dd3d0-fda1-31a8-9a74-8764e9d2a75e'}).sort({epoch:-1}).limit(1)"
	mongo bearloc --eval "db.data.find({id:'9026086e-bd07-3f96-9622-757da2907a93'}).sort({epoch:-1}).limit(1)"

server_clean:
	mongo bearloc --eval "db.data.remove()"

sync_server:
	rsync Makefile galaxy:~/
	rsync -r galaxy:~/data/ ./data/
	rsync -r data/ galaxy:~/data/

publish:
	sudo cp -r data/* /home/cs281/data
