#!/bin/bash
# Optional reconnect to WiFi after enrollment removal
SSIDINFO="Translation 10 Jay"
PASSWORDINFO="WeAreGr8"
# Removing JAMF MDM Profile
echo "Removing MDM profile..."
/usr/local/jamf/bin/jamf removeMdmProfile
sleep 5
# Removing JAMF Framework
echo "Removing JAMF Framework"
jamf removeframework
sleep 10
# Removing user profiles left behind
echo "Removing other profiles left behind..."
# Exclude system/default accounts
SkipUsers='Shared\|_\|nobody\|root\|daemon'
for username in $(dscl . list /Users | grep -v $SkipUsers)
do
identifier="$(/usr/bin/profiles -L -U "$username" | awk "/attribute/" | awk '{print $4}')"
echo "Removing profile: $identifier"
/usr/bin/profiles -R -p "$identifier" -U "$username"
done
sleep 10
# WiFi
networksetup -setairportnetwork en0 "$SSIDINFO" "$PASSWORDINFO"
sleep 20
#Check for DEP Enrollment
/usr/libexec/mdmclient dep nag
sudo profiles renew -type enrollment
sudo profiles -N


echo "This is the users home folder name" "$HOME"

echo "Removing MDM Script"


rm "./$0"

