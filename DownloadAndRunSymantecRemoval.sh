#!/bin/sh

#  DownloadAndRunSymantecRemoval.sh
####################################################################################################
#
####################################################################################################
#

# Vendor supplied PKG file
VendorZIP="1638822915058__SymantecRemovalTool.8.0.3.zip"

if [ ! -d '/Applications/Symantec Solutions' ]; then
# Symantec not installed, Exit
exit 0
else
# Download vendor supplied DMG file into /tmp/
curl -L https://github.com/mcainiom/PublicScripts/raw/main/$VendorZIP -o /tmp/$VendorZIP

unzip -o /tmp/$VendorZIP -d /tmp

sh /tmp/SymantecRemovalTool/SymantecRemovalTool.command

exit 0
fi
