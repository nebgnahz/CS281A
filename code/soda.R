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

phone_time_split = start_time + 12.6 + event_time
phone$ts2 <- phone$ts - min(phone$ts, na.rm=T)
phone$posixlt <- start_time + phone$ts2/1E9
phone$label = "unknown"
phone[phone$posixlt > phone_time_split[1] & phone$posixlt < phone_time_split[2], 'label'] = l[1]
phone[phone$posixlt > phone_time_split[2] & phone$posixlt < phone_time_split[3], 'label'] = l[2]
phone[phone$posixlt > phone_time_split[3] & phone$posixlt < phone_time_split[4], 'label'] = l[3]
phone[phone$posixlt > phone_time_split[4] & phone$posixlt < phone_time_split[5], 'label'] = l[4]
phone[phone$posixlt > phone_time_split[5] & phone$posixlt < phone_time_split[6], 'label'] = l[5]
phone[phone$posixlt > phone_time_split[6] & phone$posixlt < phone_time_split[7], 'label'] = l[6]
phone[phone$posixlt > phone_time_split[7] & phone$posixlt < phone_time_split[8], 'label'] = l[7]
phone[phone$posixlt > phone_time_split[8] & phone$posixlt < phone_time_split[9], 'label'] = l[8]
phone_x <- ggplot(phone, aes(x = posixlt, y = x)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
phone_y <- ggplot(phone, aes(x = posixlt, y = y)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
phone_z <- ggplot(phone, aes(x = posixlt, y = z)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
multiplot(phone_x, phone_y, phone_z)

glass_time_split = start_time + 6 + event_time
glass$ts2 <- glass$ts - min(glass$ts, na.rm=T)
glass$posixlt <- start_time + glass$ts2/1E9
glass$label = "unknown"
glass[glass$posixlt > glass_time_split[1] & glass$posixlt < glass_time_split[2], 'label'] = "walking"
glass[glass$posixlt > glass_time_split[2] & glass$posixlt < glass_time_split[3], 'label'] = "upstairs"
glass[glass$posixlt > glass_time_split[3] & glass$posixlt < glass_time_split[4], 'label'] = "standing"
glass[glass$posixlt > glass_time_split[4] & glass$posixlt < glass_time_split[5], 'label'] = "downstairs"
glass[glass$posixlt > glass_time_split[5] & glass$posixlt < glass_time_split[6], 'label'] = "standing"
glass[glass$posixlt > glass_time_split[6] & glass$posixlt < glass_time_split[7], 'label'] = "walking"
glass[glass$posixlt > glass_time_split[7] & glass$posixlt < glass_time_split[8], 'label'] = "running"
glass_x <- ggplot(glass, aes(x = posixlt, y = x)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
glass_y <- ggplot(glass, aes(x = posixlt, y = y)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
glass_z <- ggplot(glass, aes(x = posixlt, y = z)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
multiplot(glass_x, glass_y, glass_z)

## pebble
pebble_time_split = start_time + 1 + event_time
pebble$ts2 <- pebble$ts - min(pebble$ts, na.rm=T)
pebble$posixlt <- start_time + pebble$ts2/1E3
pebble$label = "unknown"
pebble[pebble$posixlt > pebble_time_split[1] & pebble$posixlt < pebble_time_split[2], 'label'] = "walking"
pebble[pebble$posixlt > pebble_time_split[2] & pebble$posixlt < pebble_time_split[3], 'label'] = "upstairs"
pebble[pebble$posixlt > pebble_time_split[3] & pebble$posixlt < pebble_time_split[4], 'label'] = "standing"
pebble[pebble$posixlt > pebble_time_split[4] & pebble$posixlt < pebble_time_split[5], 'label'] = "downstairs"
pebble[pebble$posixlt > pebble_time_split[5] & pebble$posixlt < pebble_time_split[6], 'label'] = "standing"
pebble[pebble$posixlt > pebble_time_split[6] & pebble$posixlt < pebble_time_split[7], 'label'] = "walking"
pebble[pebble$posixlt > pebble_time_split[7] & pebble$posixlt < pebble_time_split[8], 'label'] = "running"
pebble_x <- ggplot(pebble, aes(x = posixlt, y = x)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
pebble_y <- ggplot(pebble, aes(x = posixlt, y = y)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
pebble_z <- ggplot(pebble, aes(x = posixlt, y = z)) + geom_point( aes(colour = factor(label),shape=factor(label)) )
multiplot(pebble_x, pebble_y, pebble_z)


## final plot
multiplot(
  phone_x, phone_y, phone_z,
  glass_x, glass_y, glass_z,
  pebble_x, pebble_y, pebble_z,
  cols = 3)
