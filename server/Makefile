.default: run

run:
	cd /home/cs281/data && python -m SimpleHTTPServer

export:
	mongoexport --host localhost --db bearloc --collection data --csv --out text.csv --fields type,id,eventnano,sysnano,x,y,z,xr,yr,zr

stat:
	mongo bearloc --eval "db.data.count()"

db_clean:
	mongo bearloc --eval "db.data.remove()"

count:
	mongoexport --host localhost --db bearloc --collection data --csv --out text.csv --fields type; sort text.csv | uniq --count
