#!/bin/bash

# This script searches a domain's Calendars for a specific Event and removes that Event from any Calendars.
# This script is written to be executed by click and the Event Title entered in the console.

# This is the path to your GAM installation and should be adjusted if changed from default.
gam="$HOME/bin/gamadv-xtd3/gam"

# If you rather run this script without console interaction, uncomment the variable below and replace Test Event with the Event Title.
#eventTitle=Test Event

# If running this script with the eventTitle variable set, comment out this line.
read -p 'Enter the Title of the Event. If the Title contains a special character, use a forward slash (\) to escape: ' eventTitle

$gam config auto_batch_min 1 all users print events matchfield summary "^${eventTitle}$" | $gam csv - gam calendar ~calendarId deleteevent eventid ~id doit