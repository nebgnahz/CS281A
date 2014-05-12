options("digits.secs"=9)
start_time <- strptime("2014-05-10 23:30:00.000000000", "%Y-%m-%d %H:%M:%OS")


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
pdf("../doc/paper/figures/eda_soda2_phone.pdf", width=7, height=12)
draw(phone_labeled, "Phone Dataset 2", -21)
dev.off()

glass_labeled <- label(glass, 5.5, event_time, l, 1E9)
pdf("../doc/paper/figures/eda_soda2_glass.pdf", width=7, height=12)
draw(glass_labeled, "Glass Dataset 2", -5.5)
dev.off()

pebble_labeled <- label(pebble, -52.5, event_time, l, 1E3)
pdf("../doc/paper/figures/eda_soda2_pebble.pdf", width=7, height=12)
draw(pebble_labeled, "Pebble Dataset 2", 52.5)
dev.off()
