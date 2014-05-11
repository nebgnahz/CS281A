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


## we should change the following to handle different type of data without copy pasting

#we may want to do EDA on seperate sets
window = 10;
dat_all <- NULL
for (i in 1:length(labels)) {
  feature1 = feature_ext(glass_dat[glass_dat$label==labels[i],], window);
  y = rep(i, dim(feature1)[1]);
  dat1 = cbind(y,feature1);
  dat_all <- rbind(dat_all, dat1)
}

dat_all[,'y'] <- as.factor(dat_all[,'y']); 

plotmatrix(dat_all[,c(2,3,15,18)], colour="gray20") + geom_smooth(method="lm")

# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('C50')
library('e1071')
