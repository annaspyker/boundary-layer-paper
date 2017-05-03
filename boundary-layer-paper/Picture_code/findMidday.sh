#! /bin/bash

# This program runs through all the pictures one month at a time, and picks out the ones
# taken at midday

# Written by: Anna Spyker 01.12.2015

# point to where the photos are located
directory='/Volumes/BRANDSPANK/2014/l_december_2014'

for entry in "$directory"/*
	do
 	echo "$entry"
 	# for each photo in the directory, strip out the time 
	hourmin1=$(stat -f "%m%t%Sm %N" "$entry" | cut -d' ' -f4 | cut -d':' -f1 -f2)
	hourmin2=$(stat -f "%m%t%Sm %N" "$entry" | cut -d' ' -f3 | cut -d':' -f1 -f2)
	
	time1="${hourmin1%?}"
	time2="${hourmin2%?}"
	
	echo "$time1"
	echo "$time2"
	
	# match time to midday (and 10 mins past to ensure you don't skip any days)
	# and copy photo to desired location
	if [ "$time1" = "12:1" ]; then
		cp -v $entry '/users/annaspyker/Dropbox/Work/Boundary Layer Analysis/DATA/Midday_Photos/1200/2014.12/'
	fi
	
	if [ "$time2" = "12:0" ]; then
		cp -v $entry '/users/annaspyker/Dropbox/Work/Boundary Layer Analysis/DATA/Midday_Photos/1200/2014.12/'
	fi

	# you will have to go through and delete any double-ups for each day
	
done
