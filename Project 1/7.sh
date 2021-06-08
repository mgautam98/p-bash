#!/bin/bash

echo -n "Current File System : "
# findmnt -T . | sed -r "s/\s+/\n/g" | sed -n "6 p"
findmnt -T . | awk '{ print $3 }' | sed -n '2 p'