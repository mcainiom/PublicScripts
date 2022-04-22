#!/bin/sh

#  DownloadAndInstallDockUtil.sh
####################################################################################################
#
####################################################################################################
#

# Vendor supplied PKG file
VendorPKG="dockutil-3.0.2.pkg"

# Download vendor supplied DMG file into /tmp/
curl -L https://github.com/mcainiom/PublicScripts/raw/main/$VendorPKG -o /tmp/$VendorPKG

sudo installer -verboseR -pkg /tmp/$VendorPKG -target /

rm -f /tmp/$VendorPKG



exit 0

