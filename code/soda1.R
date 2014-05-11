###########################################################################
### soda 
###########################################################################
options("digits.secs"=9)
start_time <- strptime("2014-05-10 23:10:00.000000000", "%Y-%m-%d %H:%M:%OS")

phone <- read.csv("../data/phone_soda.csv", header=F)
colnames(phone) <- c("ts", "x", "y", "z")
glass <- read.csv("../data/glass_soda.csv", header=F)
colnames(glass) <- c("ts", "x", "y", "z")
pebble <- read.csv("../data/pebble_soda.csv", header=F)
colnames(pebble) <- c("ts", "x", "y", "z")

event_time <- c(14, 28, 59.1, 60.4, 92, 96, 100, 112, 140)
l <- c("walking", "upstairs", "standing", "downstairs", "standing", "walking", "running", "walking")

## label(data, drift, event_time, l)
phone_labeled <- label(phone, 12.6, event_time, l, 1E9)
draw(phone_labeled)

glass_labeled <- label(glass, 6, event_time, l, 1E9)
draw(glass_labeled)

pebble_labeled <- label(pebble, 1, event_time, l, 1E3)
draw(pebble_labeled)
