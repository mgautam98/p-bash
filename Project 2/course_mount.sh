#! /bin/bash

programname=$0

# function for usage
usage() {
    echo "usage: $programname [-h] [-m course] [-u course]"
    echo "$programname  -h              To print the help message"
    echo "$programname  -m  -c [course] For mounting a given course"
    echo "$programname  -u  -c [course] For unmounting a given course"
    echo "If course name is ommited all courses will be (un)mounted"
    exit 1
}

courses=(
"Linux_course/Linux_course1"
"Linux_course/Linux_course2"
"SQLFundamentals1"
)

#function to check mount exists
check_mount() {
    # Return 0 if mount exists 1 if not exists
}

#function for mount a course
mount_course() {
    # Check if the given course exists in course array
    # Check if the mount is already exists
    # Create directory in target
    # Set permissions
    # Mount the source to target
}

# function to mount all courses
mount_all() {
    # Loop through courses array
    # call mount_course
}

# function for unmount course
unmount_course() {
    # Check if mount exists
    # If mount exists unmount and delete directory in target folder
}

# function for unmount all courses
unmount_all() {
    # Loop through courses array
    # call unmount_course
}

[ -z $1 ] && { usage; }