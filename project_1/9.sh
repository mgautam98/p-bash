#! /bin/bash

echo -n "Listing All Mounts: \n"
lsblk -fs | awk '{ print $1, $2}'  


# Alternative
echo -n "Alternative: Listing All Mounts: \n"
cat /proc/mounts