## loading all necessary functions that are used for parsing the data
source("parsing.R")

load_data = "soda2"
if (load_data == "soda1") {
  source("soda1.R")
} else if (load_data == "soda2") {
  source("soda2.R")
}

labels <- c("standing", "walking", "upstairs", "downstairs", "running")

glass_dat <- glass_labeled[glass_labeled$label != "unknown",]
phone_dat <- phone_labeled[phone_labeled$label != "unknown",]
pebble_dat <- pebble_labeled[pebble_labeled$label != "unknown",]

## the following is used to draw legends
## pdf("../doc/paper/figures/legend.pdf", width=8, height=8)
## ggplot(phone_dat, aes(x = posixlt, y = x)) +
##   geom_point( aes(colour = factor(label),shape=factor(label)), size = 5, alpha = 1 ) +
##   xlab("time") +
##   ylab("accelerometer x") +
##   theme_bw() +
##   theme(legend.position = "top",
##         text = element_text(size = 20)) +
##   scale_fill_discrete(name = "New Legend Title") +
##   ggtitle(title)
## dev.off()



## we should change the following to handle different type of data without copy pasting

#we may want to do EDA on seperate sets
window = 10;
dat_all <- NULL
for (i in 1:length(labels)) {
  sub_data <- glass_dat[glass_dat$label==labels[i],]
  feature1 = feature_ext(sub_data, window);
  y = rep(i, dim(feature1)[1]);
  dat1 = cbind(y,feature1);
  T = dim(feature1)[1]
  tt = seq(min(sub_data$posixlt),max(sub_data$posixlt),length.out=T)
  dat1 = cbind(dat1,tt);
  dat_all <- rbind(dat_all, dat1)
}

dat_all[,'y'] <- as.factor(dat_all[,'y']); 
dat_all$Index <- seq(1,length(dat_all$y))

plotmatrix(dat_all[,c(2,3,15,18)], colour="gray20") + geom_smooth(method="lm")


pdf('~/features.pdf',width=10,height=7)
a1 <-ggplot(dat_all, aes(x = Index, y = mean_y)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))
a2 <-ggplot(dat_all, aes(x = Index, y = var_x)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))
a3 <-ggplot(dat_all, aes(x = Index, y = diff_x)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))
a4 <-ggplot(dat_all, aes(x = Index, y = fft_z)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))
a5 <-ggplot(dat_all, aes(x = Index, y = entropy_y)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))
a6 <-ggplot(dat_all, aes(x = Index, y = cov_xy)) +
  geom_point( aes(colour = y,shape=y)) + 
  theme(panel.background = element_rect(fill = 'white', colour = 'grey'))

multiplot(a1, a2, a3, a4, a5,a6,cols = 2)

dev.off()
# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('C50')
library('e1071')
