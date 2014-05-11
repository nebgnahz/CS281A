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

## data <- read.csv("http://galaxy.eecs.berkeley.edu:8000/data1.csv")
data <- read.csv("http://galaxy.eecs.berkeley.edu:8000/log_hopefully_phone_glass.csv")

## clean up on time, now it should be easier for us to interprate the time
options("digits.secs"=9)
phone_start_time <- strptime("2014-05-10 13:13:00.000000000", "%Y-%m-%d %H:%M:%OS")
glass_start_time <- strptime("2014-05-10 13:13:00.000000000", "%Y-%m-%d %H:%M:%OS")

phone <- data[data$id == "9026086e-bd07-3f96-9622-757da2907a93",]
glass <- data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e",]

phone$ts2 <- phone$sysnano - min(phone$sysnano, na.rm=T)
phone$posixlt <- phone_start_time + phone$ts2/1E9
phone_plot <- ggplot(phone, aes(x = posixlt, y = x)) + geom_point()
glass$ts2 <- glass$sysnano - min(glass$sysnano, na.rm=T)
glass$posixlt <- glass_start_time + glass$ts2/1E9
glass_plot <- ggplot(glass, aes(x = posixlt, y = x)) + geom_point()

phone_acc <- phone[phone$type == "accelerometer",]
glass_acc<- glass[glass$type == "accelerometer",]

phone_gyro<- phone[phone$type == "gyroscope",]
glass_gyro <- glass[glass$type == "gyroscope",]

par(mfrow = c(2, 1))
plot(1:length(phone$ts2), phone$ts2)
plot(1:length(glass$ts2), glass$ts2)

## multiplot(x_axis, y_axis, z_axis, phone_acc_plot)
glass_acc_plot <- ggplot(glass_acc, aes(x = posixlt, y = y)) + geom_point() +
  geom_vline(xintercept = as.numeric( glass_start_time + c(12, 33, 52, 70, 90, 100) - 2 ))
## multiplot(x_axis, y_axis, z_axis, phone_acc_plot)
phone_acc_plot <- ggplot(phone_acc, aes(x = posixlt, y = y)) + geom_point() +
  geom_vline(xintercept = as.numeric( phone_start_time + c(12, 33, 52, 70, 90, 100) - 3 ))
multiplot(glass_acc_plot, phone_acc_plot)

glass_acc$label=0
time_split = glass_start_time + c(12, 33, 52, 70, 90, 100) - 2 
glass_acc[glass_acc$posixlt>time_split[1]&glass_acc$posixlt<time_split[2],'label']=1
glass_acc[glass_acc$posixlt>time_split[2]&glass_acc$posixlt<time_split[3],'label']=2
glass_acc[glass_acc$posixlt>time_split[3]&glass_acc$posixlt<time_split[4],'label']=3
glass_acc[glass_acc$posixlt>time_split[4]&glass_acc$posixlt<time_split[5],'label']=4
glass_acc[glass_acc$posixlt>time_split[5]&glass_acc$posixlt<time_split[6],'label']=5
g_glass <- ggplot(glass_acc, aes(x = posixlt, y = y)) + geom_point(aes(colour = factor(label),shape=factor(label)))
  
phone_acc$label=0
time_split = phone_start_time + c(12, 33, 52, 70, 90, 100) - 3
phone_acc[phone_acc$posixlt>time_split[1]&phone_acc$posixlt<time_split[2],'label']=1
phone_acc[phone_acc$posixlt>time_split[2]&phone_acc$posixlt<time_split[3],'label']=2
phone_acc[phone_acc$posixlt>time_split[3]&phone_acc$posixlt<time_split[4],'label']=3
phone_acc[phone_acc$posixlt>time_split[4]&phone_acc$posixlt<time_split[5],'label']=4
phone_acc[phone_acc$posixlt>time_split[5]&phone_acc$posixlt<time_split[6],'label']=5
g_phone <- ggplot(phone_acc, aes(x = posixlt, y = y)) + geom_point(aes(colour = factor(label),shape=factor(label)))

multiplot(g_glass, g_phone)

glass_dat <- glass_acc[glass_acc$label!=0,]
phone_dat <- phone_acc[phone_acc$label!=0,]

### below should be updated

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

norm_vec <- function(x) sqrt(sum(x^2))
#calculate binned distribution
bin_dist <- function(x,n){
  N = length(x);
  if (max(x)==min(x))
  {
    return(c(1,rep(0,N-1)))
  }
  step = (max(x)-min(x))/n;
  bins = seq(min(x),max(x),by=step);
  b <- hist(x,breaks=bins,plot=FALSE);
  proba = b$count/N;
  return(proba);
}
#calculate entropy based on binned distribution
bin_entropy <- function(dist){
  dist = dist[dist>1e-10];
  return(sum(-dist*log(dist)))
}

## time and frequency domain feature extraction
feature_ext <- function(data,window_size){

  mean_x=c();mean_y=c();mean_z=c();var_x=c();var_y=c();var_z=c();
  cov_xy=c();cov_yz=c();cov_zx=c();magnitude=c();
  diff_x=c();diff_y=c();diff_z=c();
  #frequency domain features
  fft_x=c();fft_y=c();fft_z=c();
  #binned distribution for each axis
  dist_x=c();dist_y=c();dist_z=c();
  entropy_x=c();entropy_y=c();entropy_z=c();
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
    n = 5;
    dist_nowx = bin_dist(data$x[seq(i,i+window_size)],n);
    dist_nowy = bin_dist(data$y[seq(i,i+window_size)],n);
    dist_nowz = bin_dist(data$z[seq(i,i+window_size)],n);
    dist_x = rbind(dist_x,dist_nowx);
    dist_y = rbind(dist_y,dist_nowy);
    dist_z = rbind(dist_z,dist_nowz);
    entropy_x = c(entropy_x,bin_entropy(dist_nowx));
    entropy_y = c(entropy_y,bin_entropy(dist_nowy));
    entropy_z = c(entropy_z,bin_entropy(dist_nowz));
    i = i +window_size;
  }
  colnames(dist_x) <- colnames(dist_x, do.NULL = FALSE, prefix = "dist_x")
  colnames(dist_y) <- colnames(dist_y, do.NULL = FALSE, prefix = "dist_y")
  colnames(dist_z) <- colnames(dist_z, do.NULL = FALSE, prefix = "dist_z")
  feature_time = data.frame(mean_x,mean_y,mean_z,var_x,var_y,var_z,cov_xy,cov_yz,cov_zx,magnitude,diff_x,
                            diff_y,diff_z);
  feature_freq = data.frame(fft_x,fft_y,fft_z);
  feature_dist = cbind(entropy_x,entropy_y,entropy_z,dist_x,dist_y,dist_z);
  return(cbind(feature_time,feature_freq,feature_dist));
}

#we may want to do EDA on seperate sets
window = 10;
feature1 = feature_ext(glass_dat[glass_dat$label==1,],window);
y = rep(1,dim(feature1)[1]);
dat1 = cbind(y,feature1);
feature2 = feature_ext(glass_dat[glass_dat$label==2,],window);
y = rep(2,dim(feature2)[1]);
dat2 = cbind(y,feature2);
feature3 = feature_ext(glass_dat[glass_dat$label==3,],window);
y = rep(3,dim(feature3)[1]);
dat3 = cbind(y,feature3);
feature4 = feature_ext(glass_dat[glass_dat$label==4,],window);
y = rep(4,dim(feature4)[1]);
dat4 = cbind(y,feature4);
feature5 = feature_ext(glass_dat[glass_dat$label==5,],window);
y = rep(5,dim(feature5)[1]);
dat5 = cbind(y,feature5);

# ggplot(feature1, aes(x = entropy_y)) + geom_histogram(aes(fill = ..count..))
#data in an uquified dataframe for model building  -glass
dat_all_glass = rbind(dat1,dat2,dat3,dat4,dat5);
dat_all_glass[,'y'] <- as.factor(dat_all_glass[,'y']); 

#we may want to do EDA on seperate sets
window = 20;
feature1 = feature_ext(phone_dat[phone_dat$label==1,],window);
y = rep(1,dim(feature1)[1]);
dat1 = cbind(y,feature1);
feature2 = feature_ext(phone_dat[phone_dat$label==2,],window);
y = rep(2,dim(feature2)[1]);
dat2 = cbind(y,feature2);
feature3 = feature_ext(phone_dat[phone_dat$label==3,],window);
y = rep(3,dim(feature3)[1]);
dat3 = cbind(y,feature3);
feature4 = feature_ext(phone_dat[phone_dat$label==4,],window);
y = rep(4,dim(feature4)[1]);
dat4 = cbind(y,feature4);
feature5 = feature_ext(phone_dat[phone_dat$label==5,],window);
y = rep(5,dim(feature5)[1]);
dat5 = cbind(y,feature5);

#data in an uquified dataframe for model building -phone
dat_all_phone = rbind(dat1,dat2,dat3,dat4,dat5);
dat_all_phone[,'y'] <- as.factor(dat_all_phone[,'y']); 

# theme_set(theme_gray(base_size = 24))
# #time domain feature distribution
# pdf('./figures/edafeature1.pdf',width=10,height=7)
# a1 = ggplot(dat_all_glass, aes(mean_x, fill=as.factor(y))) +geom_density(alpha = 0.2)
# a2 = ggplot(dat_all_glass, aes(var_z, fill=as.factor(y))) +geom_density(alpha = 0.2)
# a3 = ggplot(dat_all_glass, aes(magnitude, fill=as.factor(y))) +geom_density(alpha = 0.2)
# a4 = ggplot(dat_all_glass, aes(diff_z, fill=as.factor(y))) +geom_density(alpha = 0.2)
# multiplot(a1, a2, a3, a4,cols=2)
# dev.off()
# 
# #frequency domain feature distribution
# 
# pdf('./281A/figures/edafeature2.pdf',width=10,height=7)
# a1 = ggplot(dat_all_glass, aes(fft_x, fill=y)) +geom_density(alpha = 0.2) 
# a2 = ggplot(dat_all_glass, aes(fft_z, fill=y)) +geom_density(alpha = 0.2)
# a3 = ggplot(dat_all_glass, aes(entropy_x, fill=y)) +geom_density(alpha = 0.2)
# a4 = ggplot(dat_all_glass, aes(entropy_z, fill=y)) +geom_density(alpha = 0.2)
# multiplot(a1, a2, a3, a4, cols = 2)
# dev.off()

# matrix scatter plot

plotmatrix(dat_all_glass[,c(2,3,15,18)], colour="gray20") + geom_smooth(method="lm")

write.csv(dat_all_glass, file = 'actionglass.csv')
# It's time for these quasi-reliable libraries
library('nnet')
library('foreign')
library('reshape2')
library('C50')
library('e1071')

# multi-class logistic regression test
dat_con_glass = dat_all_glass[,1:20]

test1 <- multinom(y ~ ., data = dat_con_glass)
pre1 = predict(test1,newdata=dat_con_glass[,2:20])
sum(pre1==dat_con_glass$y)/length(pre1)
table(pre1,dat_con_glass$y)

dat_con_phone = dat_all_phone[,1:20]
test1 <- multinom(y ~ ., data = dat_con_phone)
pre1 = predict(test1,newdata=dat_con_phone[,2:20])
sum(pre1==dat_con_phone$y)/length(pre1)
table(pre1,dat_con_phone$y)



# multi-class decision tree J48
test2 <- J48( y ~ mean_x + var_z + magnitude , data= dat_all_glass, control= Weka_control(M=1,U=TRUE))

# multi-class decision tree C4.5
test3 <- C5.0(as.factor(y) ~ ., data = dat_con_glass)
pre3 = predict(test3,newdata=dat_con_glass[,2:20])
sum(pre3==dat_con_glass$y)/length(pre3)
table(pre3,dat_con_glass$y)

test3 <- C5.0(as.factor(y) ~ ., data = dat_con_phone)
pre3 = predict(test3,newdata=dat_con_phone[,2:20])
sum(pre3==dat_con_phone$y)/length(pre3)
table(pre3,dat_con_phone$y)

# multi-class svm 
test4 <- svm(y ~ .,data=dat_con_glass)
pre4 = predict(test4,newdata=dat_con_glass[,2:20])
sum(pre4==dat_con_glass$y)/length(pre4)



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


