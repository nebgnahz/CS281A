## loading all necessary functions that are used for parsing the data
source("parsing.R")

load_data = "soda2"
if (load_data == "soda1") {
  source("soda1.R")
} else if (load_data == "soda2") {
  source("soda2.R")
}

## the following is a copy paste from previous files, we may need to change how they are written such that it's easier to load them

glass_dat <- glass_labeled[glass_labeled$label != "unknown",]
phone_dat <- phone_labeled[phone_labeled$label != "unknown",]
pebble_dat <- pebble_labeled[pebble_labeled$label != "unknown",]

#we may want to do EDA on seperate sets
window = 10;
feature1 = feature_ext(glass_dat[glass_dat$label=="standing",],window);
y = rep(1,dim(feature1)[1]);
dat1 = cbind(y,feature1);
feature2 = feature_ext(glass_dat[glass_dat$label=="walking",],window);
y = rep(2,dim(feature2)[1]);
dat2 = cbind(y,feature2);
feature3 = feature_ext(glass_dat[glass_dat$label=="upstairs",],window);
y = rep(3,dim(feature3)[1]);
dat3 = cbind(y,feature3);
feature4 = feature_ext(glass_dat[glass_dat$label=="downstairs",],window);
y = rep(4,dim(feature4)[1]);
dat4 = cbind(y,feature4);
feature5 = feature_ext(glass_dat[glass_dat$label=="running",],window);
y = rep(5,dim(feature5)[1]);
dat5 = cbind(y,feature5);

# ggplot(feature1, aes(x = entropy_y)) + geom_histogram(aes(fill = ..count..))
#data in an uquified dataframe for model building  -glass
dat_all_glass = rbind(dat1,dat2,dat3,dat4,dat5);
dat_all_glass[,'y'] <- as.factor(dat_all_glass[,'y']); 

plotmatrix(dat_all_glass[,c(2,3,15,18)], colour="gray20") + geom_smooth(method="lm")

write.csv(dat_all_glass, file = 'action_glass.csv')



# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('C50')
library('e1071')
