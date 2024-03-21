#!/bin/bash

# This script generates two reports, one of publically exposed Drive files and one of Drive files shared openly via link. 
# These reports are then uploaded to reportOwner's Drive and an email is sent to their account alerting them to the file's availability. 

# This script requires the installation of Python and the downloaded file GetSharedExternallyDriveACLs.py (https://github.com/taers232c/GAM-Scripts3/blob/master/GetSharedExternallyDriveACLs.py).

# This is the path to your GAM installation and should be adjusted if changed from default.
gam="$HOME/bin/gamadv-xtd3/gam"

# This is email of the User who will own the reports and be alerted to their availability.
reportOwner="user@test.com"

$gam config auto_batch_min 1 redirect csv ./public_exposure.csv multiprocess all users print filelist filepath id title owners query "visibility='anyoneCanFind' or visibility='anyoneWithLink'" &&
$gam user $reportOwner add drivefile localfile public_exposure.csv &&
$gam sendemail to $reportOwner subject "New Report Available" message "A new report, public_exposure.csv, is now available to you. To review this report, please go to your Google Drive (drive.google.com)." &&
$gam config auto_batch_min 1 redirect csv ./filelistperms.csv multiprocess all users print filelist fields id,name,permissions,owners.emailaddress,mimetype &&
python3 GetSharedExternallyDriveACLs.py filelistperms.csv external_shares.csv &&
$gam user $reportOwner add drivefile localfile external_shares.csv &&
$gam sendemail to $reportOwner subject "New Report Available" message "A new report, external_shares.csv, is now available to you. To review this report, please go to your Google Drive (drive.google.com)."