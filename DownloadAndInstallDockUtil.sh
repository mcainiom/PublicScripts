#!/bin/sh

#  DownloadAndInstallDockUtil.sh
####################################################################################################
#
####################################################################################################
#

# Vendor supplied PKG file
log="/var/log/Dockutil.log"

exec 1>> $log 2>&1

weburl=$(curl -s https://api.github.com/repos/kcrawford/dockutil/releases/latest \
        | grep browser_download_url \
        | cut -d '"' -f 4)
curl -L -o $tempfile $weburl

echo "Download URL is $weburl"

installer -verboseR -pkg $tempfile -target /

exit 0
