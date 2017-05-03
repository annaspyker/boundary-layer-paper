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
setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/data/AK1503")
data.path = ("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/data/AK1503/")

# Clear all objects
rm(list = ls(all = TRUE))

datetime = "2015-03-01 12:00"

# Load some data
# Get file list
# The path will probably need to be changed
file.list <- list.files(path = data.path, ".DAT$", full.names = TRUE)
# Filter to single day
file.list <- file.list[grep("A5030112.DAT", file.list)]

# Load backscatter data
data.backscatter <- parse_ceilometer_data(file.list)
# Function can also be used like: parse_ceilometer_data(file.list)

# Look at the data
head(data.backscatter)

# Change wd
setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")

# Remove artifact
# Load look-up table
data.artifact <- read.csv("ceilometer_artifact_signal.csv") %>% 
  mutate(backscatter = ifelse(is.na(backscatter), 0, backscatter)) %>% 
  select(height, backscatter.artifact = backscatter)

# Subtract artifact from signal
data.backscatter <- data.backscatter %>% 
  left_join(data.artifact, by = "height") %>% 
  mutate(backscatter = backscatter - backscatter.artifact, 
         backscatter = as.integer(backscatter)) %>% 
  select(-backscatter.artifact)

# Apply a rolling filter, every profile a 125 m rolling mean
data.backscatter <- data.backscatter %>% 
  group_by(date) %>% 
  mutate(backscatter = rollmean(backscatter, 125 / 5, fill = NA),  
         backscatter = as.integer(backscatter)) %>% 
  ungroup()

# Aggregate data by 10 minutes and do some conditional massaging
data.ten.min <- data.backscatter %>% 
  mutate(date = round_date_interval(date, "10 min")) %>% 
  group_by(date, height) %>% 
  summarise(backscatter = mean(backscatter)) %>% 
  ungroup() %>% 
  mutate(backscatter.massaged = ifelse(backscatter >= 200, 200, backscatter), 
         backscatter.massaged = ifelse(
           backscatter.massaged <= 0, 0, backscatter.massaged))

# Look at the aggregate data
head(data.ten.min)


# Plot all loaded data as a surface
data.ten.min %>% 
  matlab_like_surface_plot("backscatter.massaged")

'''
# Filter to a single profile
data.single.profile <- data.ten.min %>%
  filter(date == ymd_hm("2013-01-29 12:00")) 

#Plot this profile
data.single.profile %>% 
  ggplot(aes(height, backscatter.massaged)) + geom_point(colour = "dodgerblue") + 
  coord_flip()
'''

# Mixing height by gradients
# Add gradient variable
data.ten.min <- data.ten.min %>% 
  group_by(date) %>% 
  mutate(gradient = c(NA, diff(backscatter))) %>% 
  ungroup()

# Filter to two hours during the afternoon
data.filter <- data.ten.min %>% 
  filter(date == ymd_hm(datetime)) 

# Estimate mixing heights with a gradient method
data.filter.summary <- data.filter %>% 
  estimate_mixing_height()

# Join the mixing heights with the profile data
data.filter <- join(data.filter, data.filter.summary, by = "date")

jpeg(file = "/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/data/Stuart/1503/plots/daily/15-03-01.png")

# Plot backscatter with mixing height estimations
data.filter %>% 
  ggplot(aes(height, backscatter, colour = as.factor(date))) +
  geom_point() + coord_flip() + facet_wrap("date") + 
  geom_vline(aes(xintercept = mixing.height), linetype = "dashed") +
  theme(legend.position = "none")

dev.off()

