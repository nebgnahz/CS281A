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
## hopefully ground truth
## 12" walking
## 33" downstairs
## 52" standing
## 70" upstairs
## 90" running
## 100" end

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

# phone_gyro<- phone[phone$type == "gyroscope",]
# glass_gyro <- glass[glass$type == "gyroscope",]

# par(mfrow = c(2, 1))
# plot(1:length(phone$ts2), phone$ts2)
# plot(1:length(glass$ts2), glass$ts2)

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
# gyro <- data[data$type == "gyroscope",]
# rotation <- data[data$type == "rotation",]
# 
# ggplot(acc, aes(x = sysnano, y = z)) + geom_point() + facet_grid(. ~ id)
# ggplot(gyro, aes(x = sysnano, y = x)) + geom_point() + facet_grid(. ~ id)
# ggplot(rotation, aes(x = sysnano, y = zr)) + geom_point() + facet_grid(. ~ id)
# ggplot(light, aes(x = sysnano, y = zr)) + geom_point() + facet_grid(. ~ id)


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

# matrix scatter plot

plotmatrix(dat_all_glass[,c(2,3,15,18)], colour="gray20") + geom_smooth(method="lm")

write.csv(dat_all_glass, file = 'action_glass.csv')
