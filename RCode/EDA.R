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


data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e", 4] <-
  data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e", 4] - mean(data[data$id == "276dd3d0-fda1-31a8-9a74-8764e9d2a75e", 4])

data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4] <-
  data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4] - mean(data[data$id == "9026086e-bd07-3f96-9622-757da2907a93", 4])

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
