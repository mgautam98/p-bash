#!/bin/bash

echo -n "Current File System : "
findmnt -T . | awk '{ print $3 }' | sed -n '2 p'