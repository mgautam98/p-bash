#! /bin/bash

# Take a access log file which is in logfmt find unique IP addresses, 
# find IP address and how many requests been made, find how many non 200 responses etc... 

# total no of requests
cat access.log | wc -l      #since each line has 1 req

# total 200 resopnses
cat access.log | grep ' 200 ' | wc -l       # e.g. "GET / HTTP/1.1" 200 1851 "

# all unique IPs
cat access.log | grep -o "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"  | sort --unique