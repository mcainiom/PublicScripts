#!/bin/bash
#set -x

############################################################################################
##
## Script to install the Crumble 1.2.9
## https://redfernelectronics.co.uk/?ddownload=19381
##
############################################################################################

# Define variables
tempfile="/tmp/Crumble.dmg"
VOLUME="/tmp/Crumble"
weburl="https://redfernelectronics.co.uk/?ddownload=19381"
appname="Crumble"
app="Crumble.app"
logandmetadir="/Library/Intune/Scripts/InstallCrumble"
log="$logandmetadir/InstallCrumble.log"
metafile="$logandmetadir/$appname.meta"
processpath="blender"
lastmodified=$(curl -sIL "$weburl" | grep -i "last-modified" | awk '{$1=""; print $0}' | awk '{ sub(/^[ \t]+/, ""); print }' | tr -d '\r')


## Check if the log directory has been created
if [ -d $logandmetadir ]; then
    ## Already created
    echo "# $(date) | Log directory already exists - $logandmetadir"
else
    ## Creating Metadirectory
    echo "# $(date) | creating log directory - $logandmetadir"
    mkdir -p $logandmetadir
fi

# start logging
exec 1>> $log 2>&1

# Begin Script Body

echo ""
echo "##############################################################"
echo "# $(date) | Starting install of $appname"
echo "############################################################"
echo ""

## Is the app already installed?
if [ -d "/Applications/$app" ]; then

  # App is already installed, we need to determine if it requires updating or not
  echo "$(date) | $appname already installed"

  #If we're running, let's just drop out quietly
  if pgrep -f $processpath; then

    echo "$(date) | $processpath is currently running, nothing we can do here"
    exit 1

  fi

  ## Let's determine when this file we're about to download was last modified
  echo "$(date) | $weburl last update on $lastmodified"

  ## Did we store the last modified date last time we installed/updated?
  if [ -d $logandmetadir ]; then

      echo "$(date) | Looking for metafile ($metafile)"
      if [ -f "$metafile" ]; then
        previouslastmodifieddate=$(cat "$metafile")
        if [[ "$previouslastmodifieddate" != "$lastmodified" ]]; then
          install="yes"
        else
          echo "$(date) | No update between previous [$previouslastmodifieddate] and current [$lastmodified]"
          exit 0
        fi
      else
        echo "$(date) | Meta file $metafile notfound, downloading anyway"
        install="yes"
      fi
      
  fi

else

  # App isn't installed, lets download and get ready for install
  install="yes"

fi

#check if we're downloading and installing
if [ $install == "yes" ]; then

    #download the file
    echo "$(date) | Downloading $appname"
    curl -L -f -o $tempfile $weburl

    echo "$(date) | Installing $appname"

    # Mount the dmg file...
    echo "$(date) | Mounting $tempfile to $VOLUME"
    hdiutil attach -nobrowse -mountpoint $VOLUME $tempfile

    # Sync the application and unmount once complete
    echo "$(date) | Copying $VOLUME/*.app to /Applications"
    rsync -a "$VOLUME"/*.app "/Applications/"

    #unmount the dmg
    echo "$(date) | Un-mounting $VOLUME"
    hdiutil detach -quiet "$VOLUME"

    #checking if the app was installed successfully
    if [ "$?" = "0" ]; then
        if [[ -a "/Applications/$app" ]]; then

            echo "$(date) | $appname Installed"
            echo "$(date) | Cleaning Up"
            rm -rf $tempfile

            echo "$(date) | Writing last modifieddate $lastmodified to $metafile"
            echo "$lastmodified" > "$metafile"

            exit 0
        else
            echo "$(date) | Failed to install $appname"
            exit 1
        fi
    else

        # Something went wrong here, either the download failed or the install Failed
        # intune will pick up the exit status and the IT Pro can use that to determine what went wrong.
        # Intune can also return the log file if requested by the admin
        
        echo "$(date) | Failed to install $appname"
        exit 1
    fi

else
    echo "$(date) | Not downloading or installing $appname"
fi
