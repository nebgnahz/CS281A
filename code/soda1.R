###########################################################################
### soda 1
###########################################################################
options("digits.secs"=9)
start_time <- strptime("2014-05-10 23:10:00.000000000", "%Y-%m-%d %H:%M:%OS")

phone <- read.csv("http://galaxy.eecs.berkeley.edu:8000/phone_soda.csv")
colnames(phone) <- c("ts", "x", "y", "z")

glass <- read.csv("http://galaxy.eecs.berkeley.edu:8000/glass_soda.csv")
colnames(glass) <- c("ts", "x", "y", "z")

pebble <- read.csv("http://galaxy.eecs.berkeley.edu:8000/pebble_soda.csv")
colnames(pebble) <- c("ts", "x", "y", "z")

event_time <- c(14, 28, 59.1, 60.4, 92, 96, 100, 112, 140)
l <- c("walking", "upstairs", "standing", "downstairs", "standing", "walking", "running", "walking")

## label(data, drift, event_time, l)
phone_labeled <- label(phone, 12.6, event_time, l, 1E9)
pdf("../doc/paper/figures/eda_soda1_phone.pdf", width=7, height=12)
draw(phone_labeled, "Phone Dataset 1", -12.6)
dev.off()


glass_labeled <- label(glass, 6, event_time, l, 1E9)
pdf("../doc/paper/figures/eda_soda1_glass.pdf", width=7, height=12)
draw(glass_labeled, "Glass Dataset 1", -6)
dev.off()

pebble_labeled <- label(pebble, 1, event_time, l, 1E3)
pdf("../doc/paper/figures/eda_soda1_pebble.pdf", width=7, height=12)
draw(pebble_labeled, "Pebble Dataset 1", -1)
dev.off()
