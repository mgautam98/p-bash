#! /bin/bash

# Usage
# 12.sh /path/to/file e.g. ./12.sh utility.txt

FILE=$1

get_version() {
    UTILITY=$1

    # check if utility installed
    if ! [ -x "$(command -v $UTILITY)" ]; then 
        echo "$UTILITY is not installed." >&2
    else
        echo -n "$UTILITY Version: "
        echo `$UTILITY --version | sed -n '1 p'`
    fi
}

# read each line from file and pass to get_version
while IFS= read -r line; do
    get_version $line
done < $FILE