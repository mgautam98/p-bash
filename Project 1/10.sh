#! /bin/bash

# Usage
# ./10.sh 2021-06-06 2021-08-15

DAYS1=`date -d  $1 +%j`
DAYS2=`date -d  $2 +%j`

YEAR1=`date -d  $1 +%Y`
YEAR2=`date -d  $2 +%Y`

ANS=$((($DAYS2 + 365*$YEAR2) - ($DAYS1 + 365*$YEAR1)))

# check if ans is negative
if [ $ANS -lt 0 ]
then ANS=$((-1*$ANS))
fi


echo -n "Difference between $1 and $2 is: $ANS days"