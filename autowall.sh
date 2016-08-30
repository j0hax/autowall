#!/bin/sh

# configuration
wget="/usr/local/bin/wget"
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
$($wget -qO $walldest/wallpaper.jpg $url)
status=$?

# change background, or give reason for wget failure
if [ $status -eq 0 ]; then
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/var/tmp/wallpaper.jpg"'
  killall Dock
else
  if [ $status -eq 3 ]; then
    echo "File I/O error. Check if you have permissions to write to $walldest." 1>&2
  elif [ $status -eq 4 ]; then
    echo "Network failure. Check your internet connection." 1>&2
  elif [ $status -eq 8 ]; then
    echo "Network failure. Server issued error response." 1>&2
  fi
  exit $status
fi
