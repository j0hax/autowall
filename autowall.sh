#!/bin/sh

# configuration
walldest="/var/tmp"

# get resolution
width=$(expr $(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $2}') \* 2)
height=$(expr $(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $4}') \* 2)

# double the queried resolution to avoid noticable artifacts
#width=$(expr $width \* 2)
#height=$(expr $height \* 2)

# URL to download picture
url="https://unsplash.it/g/$width/$height/?random"

# download the image
$(curl -so $walldest/wallpaper.jpg $url)
status=$?

# change background, or give reason for wget failure
if [ $status -eq 0 ]; then
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/var/tmp/wallpaper.jpg"'
  killall Dock
else
  echo "cURL returned error $status. Check your internet connection and if you have permissions to write to $walldest." 1>&2
  exit $status
fi
