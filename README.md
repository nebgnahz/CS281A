# _Activity Recognition_

_Description: This is the repository for [CS281A](http://www.cs.berkeley.edu/~jordan/courses/281A-spring14/)_

## Introduction
A high-level goal of this project is to evaluate how activity recoginition algorithms perform with different sensor positions. Previous research has primarily focused on using mobile phone as the platform for activity recoginition. We argue that with the emerging wearable technology, different tasks will be offloaded to sensors that are place at different positions. Specifically for activity recoginition, sensors on Glass might perform better than sensors in mobile phone for certain gestures.

In this project, we seek to quantify the difference.


## server information
- Server address:  
	galaxy.eecs.berkeley.edu:8000

- username  
	cs281

- data url:  
	http://galaxy.eecs.berkeley.edu:8000/
	
- Export data from mongodb command:  
    mongoexport --host localhost --db bearloc --collection data --csv --out data1.csv --fields type,id,eventnano,sysnano,x,y,z,xr,yr,zr

- Data Collected:  
  I've collected another round of data, they are now on the [server](http://galaxy.eecs.berkeley.edu:8000) with name: `log_glass_phone.csv` and `log_pebble.csv`. The groundtruth can be extracted from the [video](https://www.dropbox.com/s/xr7rfiolz5x6mxo/2014-05-03%2023.00.29.mov).
