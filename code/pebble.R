pebble_data <- read.csv("http://galaxy.eecs.berkeley.edu:8000/log_hopefully_pebble.csv", header=F)

## pebble_data <- read.csv("../data/logfile_cleaned.csv", header=F)

## data clean and re-formmatting
colnames(pebble_data) <- c("ts", "x", "y", "z", "isV")

## use to identify timestamp outliers
## d <- diff(pebble_data$ts)
## which( d == max(d)) 

options("digits.secs"=3)
start_time <- strptime("2014-05-03 15:58:06.737", "%Y-%m-%d %H:%M:%OS")
pebble_data$ts2 <- pebble_data$ts - min(pebble_data$ts)
pebble_data$posixlt <- start_time +  pebble_data$ts2 / 1000

## head(pebble_data)
##             ts  x    y     z    isV ts2                 posixlt
## 1 1.399158e+12 48 -272  -952  false   0 2014-05-03 15:58:06.736
## 2 1.399158e+12 16 -248  -968  false  40 2014-05-03 15:58:06.776
## 3 1.399158e+12 48 -240 -1040  false  80 2014-05-03 15:58:06.816
## 4 1.399158e+12 56 -256  -976  false 120 2014-05-03 15:58:06.856
## 5 1.399158e+12 64 -264  -952  false 160 2014-05-03 15:58:06.897
## 6 1.399158e+12 40 -248  -976  false 200 2014-05-03 15:58:06.937
## >

## ggplot preliminary EDA
x_axis <- ggplot(pebble_data, aes(x = posixlt, y = x)) + geom_point()
y_axis <- ggplot(pebble_data, aes(x = posixlt, y = y)) + geom_point()
z_axis <- ggplot(pebble_data, aes(x = posixlt, y = z)) + geom_point()

plot.new()
frame()
multiplot(x_axis, y_axis, z_axis)
