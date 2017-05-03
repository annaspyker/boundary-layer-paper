# Boundary layer analysis

library(xlsx); library(plyr); library(ggplot2); library(lubridate); library(gridExtra)
library(ggplot2); library(reshape2); library(zoo); library(scales); library(dplyr); library(openair)

# set working directory
setwd('/Users/lenaweissert/Dropbox/Boundary layer analysis/Anna Spyker/analysis/')            

# remove all
rm(list=ls(all=T))

# Load data
met <- read.csv('/Users/lenaweissert/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Wind and Temperature data/mangere_temp_2012ff.csv',header = TRUE,sep=",", stringsAsFactors = FALSE)%>%
  mutate (date = ymd_hm(date))

met$rh <- as.numeric(as.character(met$rh))

blh <- read.csv('/Users/lenaweissert/Dropbox/Boundary layer analysis/Anna Spyker/code/Temperature method/Wind and Temperature data/12-00_final_updated.csv', sep= ",", stringsAsFactors = F) %>%
  mutate (date = dmy_hm(date))

blh$tair <- as.numeric(as.character(blh$tair))
blh$wd <- as.numeric(as.character(blh$wd))
blh$ws <- as.numeric(as.character(blh$ws))
blh$found.correctly<- as.numeric(as.character(blh$found.correctly))
blh$found.correctly.1<- as.numeric(as.character(blh$found.correctly.1))

# Choose data at midday only
met.sub <- selectByDate(met, hour = 12) %>%
  select(date, rh)

met.sub$rh <- as.numeric(as.character(met.sub$rh))

# merge midday met data with blh
blh.updated <- merge(blh, met.sub, by = 'date')

# Write csv file
write.csv(blh, '/Users/lenaweissert/Dropbox/Boundary layer analysis/Anna Spyker/analysis/blh_updated.csv')

