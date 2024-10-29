#!/bin/bash

# This script returns all regular Calendar Events as a csv. This can be run for the day, a specific day, or a range of days.
# This script is written to be executed by click and configured in the console.

# This is the path to your GAM installation and should be adjusted if changed from default.
gam="$HOME/bin/gamadv-xtd3/gam"

# The Google Drive account that should own the resulting csv upload.
owner="test@yourDomain.com"

# Function selection and creation of date variable.
PS3="Select the Calendar Date: "
options=("Today" "Specific Day" "Custom Range")


# The function for selecting Today.
function today {
  date=$(date '+%Y-%m-%d')
	yesterday=$(date -v -1d '+%Y-%m-%d')
	tomorrow=$(date -v +1d '+%Y-%m-%d')
	$gam config auto_batch_min 1 redirect csv ./$date.csv multiprocess all users print events singleevents eventtype default before $tomorrow after $yesterday timemin $date"T00:00:00+00:00" && $gam user $owner add drivefile localfile $date.csv
}

# The function for selecting Custom Range.
function customRange {
  read -p 'Enter the date before the target date in yyyy-mm-dd format (2024-01-01 for target 2024-01-02): ' yesterday
  read -p 'Enter the date after the target date in yyyy-mm-dd format (2024-01-03 for target 2024-01-02): ' tomorrow
  date=$(date -j -f "%Y-%m-%d" "$(date -j -v +1d -f "%Y-%m-%d" $yesterday "+%Y-%m-%d")" "+%Y-%m-%d")
  $gam config auto_batch_min 1 redirect csv ./$yesterday-and-$tomorrow.csv multiprocess all users print events singleevents eventtype default before $tomorrow after $yesterday timemin $date"T00:00:00+00:00" && $gam user $owner add drivefile localfile $yesterday-and-$tomorrow.csv

}

# The function for selecting Specific Day.
function specificDay {
  read -p 'Enter the specific date in yyyy-mm-dd format (2024-01-02): ' targetDay
  yesterday=$(date -j -f "%Y-%m-%d" "$(date -j -v -1d -f "%Y-%m-%d" $targetDay "+%Y-%m-%d")" "+%Y-%m-%d")
  tomorrow=$(date -j -f "%Y-%m-%d" "$(date -j -v +1d -f "%Y-%m-%d" $targetDay "+%Y-%m-%d")" "+%Y-%m-%d")
  $gam config auto_batch_min 1 redirect csv ./$targetDay.csv multiprocess all users print events singleevents eventtype default before $tomorrow after $yesterday timemin $targetDay"T00:00:00+00:00" && $gam user $owner add drivefile localfile $targetDay.csv
}

# Runs the selected option and associated function.
select option in "${options[@]}"; do
	case $option in
		"Today")
		  today
		  break
		  ;;
		"Specific Day")
		  specificDay
		  break
		  ;;
	  "Custom")
	    customRange
	    break
	    ;;
  esac
done