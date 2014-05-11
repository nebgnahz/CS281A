options("digits.secs"=9)
start_time <- strptime("2014-05-10 23:10:00.000000000", "%Y-%m-%d %H:%M:%OS")


phone <- read.csv("http://galaxy.eecs.berkeley.edu:8000/phone_soda2.csv")
colnames(phone) <- c("ts", "x", "y", "z")

glass <- read.csv("http://galaxy.eecs.berkeley.edu:8000/glass_soda2.csv")
colnames(glass) <- c("ts", "x", "y", "z")

pebble <- read.csv("http://galaxy.eecs.berkeley.edu:8000/pebble_soda2.csv")
colnames(pebble) <- c("ts", "x", "y", "z")

event_time <- c(21, 85, 137, 179, 227, 282, 290, 328)
l <- c("walking", "upstairs", "standing", "downstairs", "standing", "walking", "running")

## label(data, drift, event_time, l)
phone_labeled <- label(phone, 21, event_time, l, 1E9)
draw(phone_labeled)

glass_labeled <- label(glass, 5.5, event_time, l, 1E9)
draw(glass_labeled)

pebble_labeled <- label(pebble, -52.5, event_time, l, 1E3)
draw(pebble_labeled)
