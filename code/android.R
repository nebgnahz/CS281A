## experiement log, reverse time order
## - 2014-04-26 17:28 | @collecting Antonio upstairs
## - 2014-04-26 17:28 | @collecting Antonio downstairs done
## - 2014-04-26 17:28 | @collecting Antonio downstairs
## - 2014-04-26 17:28 | @collecting Antonio upstairs done
## - 2014-04-26 17:26 | @collecting Antonio jogging
## - 2014-04-26 17:26 | @collecting Antonio jogging done
## - 2014-04-26 17:25 | @collecting Antonio walk
## - 2014-04-26 17:25 | @collecting Antonio walk done
## - 2014-04-26 17:24 | @collecting Antonio standing
## - 2014-04-26 17:24 | @collecting Antonio standing done


data <- read.csv("http://galaxy.eecs.berkeley.edu:8000/data1.csv")

## clean up on time, now it should be easier for us to interprate the time
options("digits.secs"=9)
phone_start_time <- strptime("2014-05-03 15:58:06.000000001", "%Y-%m-%d %H:%M:%OS")
glass_start_time <- strptime("2014-05-03 15:59:01.000000001", "%Y-%m-%d %H:%M:%OS")

phone <- data[data$id == "9026086e-bd07-3f96-9622-757da2907a93",]
glass <- data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e",]

phone$ts2 <- phone$sysnano - min(phone$sysnano)
phone$posixlt <- phone_start_time + phone$ts2/1E9
glass$ts2 <- glass$sysnano - min(glass$sysnano)
glass$posixlt <- glass_start_time + glass$ts2/1E9


data$ts[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e"] <-
  (data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e", 4] - min(data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e", 4])) / 1E9

data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4] <-
  data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4] - min(data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4]) / 1000000000 + start_time

acc <- data[data$type == "accelerometer",]
gyro <- data[data$type == "gyroscope",]
rotation <- data[data$type == "rotation",]

ggplot(acc, aes(x = sysnano, y = z)) + geom_point() + facet_grid(. ~ id)
ggplot(gyro, aes(x = sysnano, y = x)) + geom_point() + facet_grid(. ~ id)
ggplot(rotation, aes(x = sysnano, y = zr)) + geom_point() + facet_grid(. ~ id)
ggplot(light, aes(x = sysnano, y = zr)) + geom_point() + facet_grid(. ~ id)


## > 
##                    type                                          id       
##  gyroscope           :24323   276dd3d0-fda1-31a8-9a74-8764e9d2a75e:32621  
##  accelerometer       :13559   9026086e-bd07-3f96-9622-757da2907a93:62968  
##  magnetic            :13552                                               
##  gravity             :13457                                               
##  linear accelerometer:13457                                               
##  rotation            :13455                                               
##  (Other)             : 3786                                               
##    eventnano            sysnano                x                 y          
##  Min.   :1.033e+13   Min.   :1.033e+13   Min.   :-55.669   Min.   :-45.171  
##  1st Qu.:1.037e+13   1st Qu.:1.037e+13   1st Qu.: -0.219   1st Qu.: -0.081  
##  Median :1.043e+13   Median :1.043e+13   Median :  0.020   Median :  0.072  
##  Mean   :1.509e+14   Mean   :1.587e+14   Mean   :  0.361   Mean   :  1.270  
##  3rd Qu.:4.448e+14   3rd Qu.:4.448e+14   3rd Qu.:  0.651   3rd Qu.:  9.393  
##  Max.   :4.451e+14   Max.   :4.451e+14   Max.   : 36.089   Max.   : 19.613  
##  NA's   :3607                            NA's   :17241     NA's   :17241    
##        z                 xr              yr              zr       
##  Min.   :-52.307   Min.   :-0.19   Min.   :-0.82   Min.   :-0.97  
##  1st Qu.: -0.028   1st Qu.: 0.00   1st Qu.:-0.58   1st Qu.:-0.63  
##  Median :  0.082   Median : 0.10   Median : 0.16   Median : 0.27  
##  Mean   :  1.332   Mean   : 0.20   Mean   : 0.02   Mean   : 0.12  
##  3rd Qu.:  0.979   3rd Qu.: 0.35   3rd Qu.: 0.68   3rd Qu.: 0.71  
##  Max.   : 30.604   Max.   : 0.84   Max.   : 0.75   Max.   : 0.97  
##  NA's   :17241     NA's   :82134   NA's   :82134   NA's   :82134  
## > 

acc_glass <- acc[acc$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e",]
acc_glass1 = acc_glass[acc_glass$sysnano>(-1e11)&acc_glass$sysnano<(-5e10),]
acc_glass2 = acc_glass[acc_glass$sysnano>(-2.5e10)&acc_glass$sysnano<0,]
acc_glass3 = acc_glass[acc_glass$sysnano>(2.5e10)&acc_glass$sysnano<(5e10),]
acc_glass4 = acc_glass[acc_glass$sysnano>(1e11)&acc_glass$sysnano<(1.3e11),]
acc_glass5 = acc_glass[acc_glass$sysnano>(1.35e11),]
ggplot(acc_glass3, aes(x = sysnano, y = z)) + geom_point() + facet_grid(. ~ id)
norm_vec <- function(x) sqrt(sum(x^2))
bin_dist <- function(x,n){
  N = length(x);
  step = (max(x)-min(x))/n;
  bins = seq(min(x),max(x),by=step);
  b <- hist(x,breaks=bins,plot=FALSE);
  proba = b$count/N;
  return(proba);
}

## time and frequency domain feature extraction
feature_ext <- function(data,window_size){
  begin_time = data[1,'sysnano'];
  end_time = data[length(data[,'sysnano']),'sysnano'];
  # winodw <- seq(from=begin_time,to=end_time,length.out=(window_num+1));
  #time domain features
  mean_x=c();mean_y=c();mean_z=c();var_x=c();var_y=c();var_z=c();
  cov_xy=c();cov_yz=c();cov_zx=c();magnitude=c();
  diff_x=c();diff_y=c();diff_z=c();
  #frequency domain features
  fft_x=c();fft_y=c();fft_z=c();
  #binned distribution for each axis
  dist_x=c();dist_y=c();dist_z=c();
  #ignore first and last window
  i = window_size;
  while (i<dim(data)[1]-2*window_size){
    
    tmp = cbind(data$x[seq(i,i+window_size)],data$y[seq(i,i+window_size)],data$z[seq(i,i+window_size)]);
    magnitude = c(magnitude,mean(apply(tmp,1,norm_vec))); 
    mean_x = c(mean_x,mean(data$x[seq(i,i+window_size)],na.rm = T));
    mean_y = c(mean_y,mean(data$y[seq(i,i+window_size)],na.rm = T));
    mean_z = c(mean_z,mean(data$z[seq(i,i+window_size)],na.rm = T));
    var_x = c(var_x,var(data$x[seq(i,i+window_size)],na.rm = T));
    var_y = c(var_y,var(data$y[seq(i,i+window_size)],na.rm = T));
    var_z = c(var_z,var(data$z[seq(i,i+window_size)],na.rm = T));
    cov_xy = c(cov_xy,cov(data$x[seq(i,i+window_size)],data$y[seq(i,i+window_size)],use='na.or.complete'));
    cov_yz = c(cov_yz,cov(data$y[seq(i,i+window_size)],data$z[seq(i,i+window_size)],use='na.or.complete'));
    cov_zx = c(cov_zx,cov(data$z[seq(i,i+window_size)],data$x[seq(i,i+window_size)],use='na.or.complete'));
    diff_x = c(diff_x,mean(diff(data$x[seq(i,i+window_size)],1)));
    diff_y = c(diff_y,mean(diff(data$y[seq(i,i+window_size)],1)));
    diff_z = c(diff_z,mean(diff(data$z[seq(i,i+window_size)],1)));
    xf = fft((data$x[seq(i,i+window_size)]));
    yf = fft((data$y[seq(i,i+window_size)]));
    zf = fft((data$z[seq(i,i+window_size)]));
    fft_x = c(fft_x,mean(Mod(xf)));
    fft_y = c(fft_y,mean(Mod(yf)));
    fft_z = c(fft_z,mean(Mod(zf)));
    n = 10;
    dist_x = rbind(dist_x,bin_dist(data$x[seq(i,i+window_size)],n));
    dist_y = rbind(dist_y,bin_dist(data$y[seq(i,i+window_size)],n));
    dist_z = rbind(dist_z,bin_dist(data$z[seq(i,i+window_size)],n));
    i = i +window_size;
  }
  colnames(dist_x) <- colnames(dist_x, do.NULL = FALSE, prefix = "dist_x")
  colnames(dist_y) <- colnames(dist_y, do.NULL = FALSE, prefix = "dist_y")
  colnames(dist_z) <- colnames(dist_z, do.NULL = FALSE, prefix = "dist_z")
  feature_time = data.frame(mean_x,mean_y,mean_z,var_x,var_y,var_z,cov_xy,cov_yz,cov_zx,magnitude,diff_x,
                            diff_y,diff_z);
  feature_freq = data.frame(fft_x,fft_y,fft_z);
  feature_dist = cbind(dist_x,dist_y,dist_z);
  return(cbind(feature_time,feature_freq,feature_dist));
}

#we may want to do EDA on seperate sets
feature1 = feature_ext(acc_glass1,50);
y = rep(1,dim(feature1)[1]);
dat1 = cbind(y,feature1);
feature2 = feature_ext(acc_glass2,50);
y = rep(2,dim(feature2)[1]);
dat2 = cbind(y,feature2);
feature3 = feature_ext(acc_glass3,50);
y = rep(3,dim(feature3)[1]);
dat3 = cbind(y,feature3);
feature4 = feature_ext(acc_glass4,50);
y = rep(4,dim(feature4)[1]);
dat4 = cbind(y,feature4);
feature5 = feature_ext(acc_glass5,50);
y = rep(5,dim(feature5)[1]);
dat5 = cbind(y,feature5);

ggplot(feature1, aes(x = mean_x)) + geom_histogram(aes(fill = ..count..))

#data in an uquified dataframe for model building
dat_all = rbind(dat1,dat2,dat3,dat4,dat5);

# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('RWeka') 
library('C50')
library('e1071')

# multi-class logistic regression test
test1 <- multinom(y ~ mean_x + var_z + magnitude, data = dat_all)
# multi-class decision tree J48
test2 <- J48( y ~ mean_x + var_z + magnitude , data= dat_all, control= Weka_control(M=1,U=TRUE))
# multi-class decision tree C4.5
test3 <- C5.0(as.factor(y) ~ mean_x + var_z + magnitude, data = dat_all)
# multi-class svm 
test4 <- svm(y ~ mean_x + var_z + magnitude,data=dat_all)

library('HMM')
library('bnlearn')
library('depmixS4')  #this one looks better
test5 <- depmix(list(mean_x~1,var_z~1,magnitude~1),data=dat_all,nstates=5,
              family=list(gaussian(),gaussian(),gaussian()));
fit_test5 <- fit(test5)
summary(fit_test5,which="all")
post5 <- posterior(fit_test5)
param5 <- forwardbackward(fit_test5, return.all=TRUE, useC=TRUE)

