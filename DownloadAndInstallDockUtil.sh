#!/bin/sh

#  DownloadAndInstallDockUtil.sh
####################################################################################################
#
####################################################################################################
#

# Vendor supplied PKG file
VendorPKG="DockUtil.pkg"

# Download vendor supplied DMG file into /tmp/
curl https://github.com/mcainiom/PublicScripts/raw/main/$VendorPKG -o /tmp/$VendorPKG

# Instsall Google Chrome
sudo installer -verboseR -pkg /tmp/$VendorPKG -target /

# Remove the downloaded vendor supplied PKG file
rm -f /tmp/$VendorPKG


exit 0

