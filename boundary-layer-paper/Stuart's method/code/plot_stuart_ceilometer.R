# plot single day ceilometer
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

# Set global options
options(stringsAsFactors = FALSE)

# Set working directory
# This will need to be changed
# office: setwd("C:/Users/lwei999/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/data/AK1503")
setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")
data.path = ("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/data/AK1502/")

date = '2015-02-27'

source('plot_single_day.R')

fig <- plot_single_day(date)
