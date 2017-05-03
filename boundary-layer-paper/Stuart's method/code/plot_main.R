# Set-up ---------------------------
# Load packages
library(stringr)
library(plyr)
library(lubridate)
library(ggplot2)
library(dplyr)
library(zoo)
library(threadr)
library(ceilr)

setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")

source("plot_single_day.R")
source("parse_ceilometer_data.R")
source("estimate_mixing_height.R")

mixing.height = NULL;
date = NULL;

dateArray = c("04", "07", "10", "14", "26", "31")
dateString = "2012-11-08"

for (i in 8:31) {
  
 # dateString = paste0(yearmonth, "-", dateArray[i])

  if (i < 10) {
    dateString = paste0("2014-05-0", i)
  } else {
    dateString = paste0("2014-05-", i)
  }
  
  print(i)
  print(dateString)
  
  mixing.height[i] = plot_single_day(dateString)
  date[i] = dateString
  
}

df = data.frame(date, mixing.height)

setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/csvfiles/")
writeString = paste0("fixed.._", yearmonth, ".csv")
write.csv(df, writeString)



setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")
source("plot_multiple_days.R")
library(xlsx)
dateString = "2012"

for (i in 5:5) {
  setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")
  if (i < 10) {
    dateString = paste0("2014-0", i)
  } else {
    dateString = paste0("2014-", i)
  }

  print(i)
  print(dateString)
  
  dataStuart <- plot_multiple_days(dateString, "12:00")

  
  setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/csvfiles/")
  writeString = paste0(dateString, ".csv")
  write.csv(dataStuart, writeString)
}
