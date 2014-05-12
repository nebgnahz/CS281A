label <- function(d, drift, event_time, l, scale) {
  d_time_split = start_time + drift + event_time
  d$ts2 <- d$ts - min(d$ts, na.rm=T)
  d$posixlt <- start_time + d$ts2/scale
  d$label = "unknown"
  for (i in 1:length(l)) {
    d[d$posixlt > d_time_split[i] & d$posixlt < d_time_split[i+1], 'label'] = l[i]
  }
  return(d)
}

draw <- function(data, title) {
  data_cleaned <- data[data$label != "unknown",]
  data_x <- ggplot(data_cleaned, aes(x = posixlt, y = x)) +
    geom_point( aes(colour = factor(label),shape=factor(label)) ) +
      xlab("time") +
        ylab("accelerometer x") +
          scale_fill_discrete(name="label") +
            theme_bw() +
              theme(legend.position="none",
                    text = element_text(size = 20)) +
                      ggtitle(title)
  data_y <- ggplot(data_cleaned, aes(x = posixlt, y = y)) +
    geom_point( aes(colour = factor(label),shape=factor(label)) ) +
      xlab("time") +
        ylab("accelerometer y") +
          scale_fill_discrete(name="label") +
            theme_bw() +
              theme(legend.position="none",
                    text = element_text(size = 20)) +
                      ggtitle(title)
  data_z <- ggplot(data_cleaned, aes(x = posixlt, y = z)) +
    geom_point( aes(colour = factor(label),shape=factor(label)) ) +
      xlab("time") +
        ylab("accelerometer z") +
          scale_fill_discrete(name="label") +
            theme_bw() +
              theme(legend.position="none",
                    text = element_text(size = 20)) +
                      ggtitle(title)
  multiplot(data_x, data_y, data_z)
}






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
