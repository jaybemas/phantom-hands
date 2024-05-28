#!/bin/bash

# This script searches a domain's Google Drive for any file that is shared with the target email and removes that access. 
# This script is written to be executed by click and the target email entered in the console. 

# This is the path to your GAM installation and should be adjusted if changed from default.
gam="$HOME/bin/gamadv-xtd3/gam"

# If you rather run this script without console interaction, uncomment the variable below and replace the test account with your target email.
#targetemail=test@example.com

# If running this script with the target email variable set, comment out this line.
read -p 'Email to be removed: ' targetemail

$gam config auto_batch_min 1 all users print filelist query "'$targetemail' in writers or '$targetemail' in readers" id corpora allDrives oneitemperrow | $gam csv - gam user "~Owner" delete drivefileacl "~id" $targetemail
