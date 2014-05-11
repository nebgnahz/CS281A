# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('e1071')
#load new data for testing
source("soda1.R")
labels <- c("standing", "walking", "upstairs", "downstairs", "running")
glass_dat_test <- glass_labeled[glass_labeled$label != "unknown",]
phone_dat_test <- phone_labeled[phone_labeled$label != "unknown",]
pebble_dat_test <- pebble_labeled[pebble_labeled$label != "unknown",]
#we may want to do EDA on seperate sets
window = 10;
dat_all_test <- NULL
for (i in 1:length(labels)) {
  feature1 = feature_ext(glass_dat_test[glass_dat_test$label==labels[i],], window);
  y = rep(i, dim(feature1)[1]);
  dat1 = cbind(y,feature1);
  dat_all_test <- rbind(dat_all_test, dat1)
}

dat_all_test[,'y'] <- as.factor(dat_all_test[,'y']); 
dat_con_test = dat_all_test[,1:20]


# multi-class logistic regression training 
dat_con = dat_all[,1:20]
test1 <- multinom(y ~ ., data = dat_con)
pre1 = predict(test1,newdata=dat_con[,2:20])
#training error
sum(pre1==dat_con$y)/length(pre1)
t1 = table(pre1,dat_con$y)
apply(t1, 1, function(x) x/sum(x))

pre1_testing = predict(test1,newdata=dat_con_test[,2:20])
#testing error
sum(pre1_testing==dat_con_test$y)/length(pre1_testing)
t1_test = table(pre1_testing,dat_con_test$y)
apply(t1_test, 1, function(x) x/sum(x))


# go to matlab for dynamic bayesian network method...
library('HMM')
library('bnlearn')
library('depmixS4')  #this one looks better
test5 <- depmix(list(mean_x~1,var_z~1,magnitude~1),data=dat_all,nstates=5,
                family=list(gaussian(),gaussian(),gaussian()));
fit_test5 <- fit(test5)
summary(fit_test5,which="all")
post5 <- posterior(fit_test5)
param5 <- forwardbackward(fit_test5, return.all=TRUE, useC=TRUE)



# regularized svm and logistic regression 
library('LiblineaR')

# # multi-class decision tree C4.5
# test3 <- C5.0(as.factor(y) ~ ., data = dat_con)
# pre3 = predict(test3,newdata=dat_con[,2:20])
# sum(pre3==dat_con$y)/length(pre3)
# t3 = table(pre1,dat_con$y)
# apply(t3, 1, function(x) x/sum(x))
# 
# # testing error for decision tree  Decision Tree overfits
# pre3_testing = predict(test3,newdata=dat_con_test[,2:20])
# #testing error
# sum(pre3_testing==dat_con_test$y)/length(pre3_testing)
# t3_test = table(pre3_testing,dat_con_test$y)
# apply(t3_test, 1, function(x) x/sum(x))
# 
# # multi-class svm 
# test4 <- svm(y ~ .,data=dat_con)
# pre4 = predict(test4,newdata=dat_con[,2:20])
# sum(pre4==dat_con$y)/length(pre4)
# t4 = table(pre4,dat_con$y)
# apply(t4, 1, function(x) x/sum(x))
# 
# #testing error for svm
# # testing error for decision tree
# pre4_testing = predict(test4,newdata=dat_con_test[,2:20])
# #testing error
# sum(pre4_testing==dat_con_test$y)/length(pre4_testing)
# t4_test = table(pre4_testing,dat_con_test$y)
# apply(t4_test, 1, function(x) x/sum(x))
