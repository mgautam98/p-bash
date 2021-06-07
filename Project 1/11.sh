#! /bin/bash

LAST_DATE=`date -d "-$(date +%d) days  month" +%d`
CURR=`date +%d`
COUNTER=`date +%d`

# add (counter - curr) to today
display() {
    date +%F -d "now + $(($1 - $CURR)) days"
}

# loop until counter ls Last date
while [ $COUNTER -le $LAST_DATE ]
do
    display $COUNTER
    ((COUNTER++))
done