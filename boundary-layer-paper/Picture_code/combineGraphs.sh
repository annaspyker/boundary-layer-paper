#! /bin/bash

# This program pattern matches each boundary layer graph and puts them all together into 
# a 'combined' photo. It runs over one month at a time. Each month of plots need to be put 
# into the same location as this function before the script is run

# Written by: Anna Spyker 01.12.2015

# input
month="12"
year="14"
pictureCode="D"

for i in {1..31}; do

	echo "$i"
	
	if [ "$i" -lt 10 ]
  		then # day is less than 10 - need to add "0" to file match
  			# match stuart's method	graph
  			stuart="20"$year"-"$month"-0"$i".png"
  			
  			# match temperature method graph
  			temperature="20"$year$month"0"$i":1200.png"
  			
  			# match ideal-profile method graph
  			#ideal="0"$i"-"$month"-20"$year"_12:00.png"
  			ideal=$year$month"0"$i".png"
  			
  			# match photo 
  			photo=$pictureCode"0"$i"1*.jpg"

  			# name of file to save
  			saveAs="20"$year"-"$month"-0"$i"_combined.png"

			# title on graph
  			title="0"$i"-"$month"-20"$year" 12pm"
 
  		else
  			
  			# match stuart's method graph
  			stuart="20"$year"-"$month"-"$i".png"

  			# match temperature method graph
  			temperature="20"$year$month$i":1200.png"
  			
  			# match ideal-profile method graph
  			#ideal=$i"-"$month"-20"$year"_12:00.png"
  			ideal=$year$month$i".png"
  			
  			# match photo
  			photo=$pictureCode$i"1*.jpg"

  			# name of file to save
  			saveAs="20"$year"-"$month"-"$i"_combined.png"

			# title on graph
  			title=$i"-"$month"-20"$year" 12pm"
	fi
	
	montage -geometry 1000x1000\>+2+2 -title "$title" -pointsize 50 $stuart $temperature $ideal $photo $saveAs
	
done
