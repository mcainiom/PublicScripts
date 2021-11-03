#!/bin/sh

#  DownloadAndInstallDockUtil.sh
####################################################################################################
#
####################################################################################################
#

# Vendor supplied PKG file
VendorZIP="dockutil.zip"

# Download vendor supplied DMG file into /tmp/
curl -L https://github.com/mcainiom/PublicScripts/raw/main/$VendorZIP -o /tmp/$VendorZIP

unzip -o /tmp/$VendorZIP -d /usr/local/bin



exit 0

