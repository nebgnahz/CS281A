# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('RWeka') 
library('C50')
library('e1071')

# multi-class logistic regression test
dat_con = dat_all[,1:20]
test1 <- multinom(y ~ ., data = dat_con)
pre1 = predict(test1,newdata=dat_con[,2:20])
sum(pre1==dat_con$y)/length(pre1)

# multi-class decision tree J48
test2 <- J48( y ~ mean_x + var_z + magnitude , data= dat_all, control= Weka_control(M=1,U=TRUE))
# multi-class decision tree C4.5
test3 <- C5.0(as.factor(y) ~ ., data = dat_con)
pre3 = predict(test3,newdata=dat_con[,2:20])
sum(pre3==dat_con$y)/length(pre3)

# multi-class svm 
test4 <- svm(y ~ .,data=dat_con)
pre4 = predict(test4,newdata=dat_con[,2:20])
sum(pre4==dat_con$y)/length(pre4)



# go to matlab for dynamic bayesian network method
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
