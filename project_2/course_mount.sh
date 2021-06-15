#!/bin/bash
################################################################################
#                              course_mount.sh
# 
# Script for mounting course data with permissions to specific users
# and groups                                                                   
# 
# Change History
# 08/06/2021  Gautam Mishra     Initial Implementation
#                               
# Dependemcy: User 'trainee', Group 'ftpaccess', bindfs
# 
# user_allow_other in /etc/fuse.conf else use with SUDO
#
# 
################################################################################
################################################################################
################################################################################
#
#   example usage:
#   ./course_mount.sh -m -c Linux_course1
#   ./course_mount.sh -u
#
################################################################################
################################################################################

# can be changed acc to need
DATA_DIR='./courses'
TRAINEE_DIR='./trainee'

COURSE_PATH=""

PROG_NAME=$0

# function for usage
usage() {
    echo "usage: $PROG_NAME [-h] [-m ] [-u course]"
    echo "$PROG_NAME  -h              To print the help message"
    echo "$PROG_NAME  -m  -c [course] For mounting a given course"
    echo "$PROG_NAME  -u  -c [course] For unmounting a given course"
    echo "If course name is ommited all courses will be (un)mounted"
    exit $1

courses=(
    "Linux_course/Linux_course1"
    "Linux_course/Linux_course2"
    "machinelearning/machinelearning1"
    "machinelearning/machinelearning2"
    "SQLFundamentals1"
    "SQLFundamentals2"
    "SQLFundamentals3"
)

# function to check mount exists
check_mount() {
    # Return 0 if mount exists 1 if not exists

    [ `findmnt | grep "$1" | grep -c bindfs` ] && return 0 || return 1
}

# function to check if course exists
check_course() {
    # return if course not exits
    for LISTED_COURSE in ${courses[@]}
    do
        COURSE_BASE=`basename $LISTED_COURSE`
        if [[ $COURSE_BASE == $1 ]]
        then
            COURSE_PATH=$DATA_DIR/$LISTED_COURSE
            return 0
        fi
    done
    echo "Course does not exists"
    exit 2
} 

# function for mount a course
mount_course() {
    # echo Mounting $1
    # Check if the given course exists in course array
    check_course $1

    # Check if the mount is already exists
    check_mount $TRAINEE_DIR/$1
    mounted=$?
    [ $mounted -eq 1 ] && return 1   # TODO: display to user if already mounted
    
    # Create directory in target
    mkdir -p $TRAINEE_DIR/$1
    
    # Set permissions
    # Mount the source to target
    bindfs -p 550 -u trainee -g ftpaccess $COURSE_PATH $TRAINEE_DIR/$1 2>> /dev/null

    [ $? -ne 0 ] && echo "Mount unsucessful for $1\n" && return 1
}

# function to mount all courses
mount_all() {
    # Loop through courses array
    # call mount_course
    for LISTED_COURSE in ${courses[@]}
    do
        COURSE_BASE=`basename $LISTED_COURSE`
        mount_course $COURSE_BASE
    done
}

# function for unmount course
unmount_course() {
    # echo Umounting $1
    # check if course exits
    check_course $1
    
    # Check if mount exists
    check_mount $TRAINEE_DIR/$1
    mounted=$?
    [ $mounted -ne 0 ] && return 1  

    # If mount exists unmount and delete directory in target folder
    umount $TRAINEE_DIR/$1 2>> /dev/null

    [ $? -ne 0 ] && echo "Unmount unsucessful for $1" && return 1

    # delete target dir
    rm -r $TRAINEE_DIR/$1 2>> /dev/null
}

# function for unmount all courses
unmount_all() {
    # Loop through courses array
    # call unmount_course
    for LISTED_COURSE in ${courses[@]}
    do
        COURSE_BASE=`basename $LISTED_COURSE`
        unmount_course $COURSE_BASE
    done
}

COURSE=""
TO_MOUNT=-1 # -1 for not set

while getopts humc: flag
do
    case "${flag}" in
        # for -h flag display usage
        h)  usage 0
        ;;
        # if -u flag set TO_MOUNT, if already set to 1 then return
        u) [ $TO_MOUNT -ne -1 ] && usage 2; TO_MOUNT=0
        ;;
        # if -m flag set TO_MOUNT, if already set to 0 then return
        m) [ $TO_MOUNT -ne -1 ] && usage 2; TO_MOUNT=1
        ;;
        # if -m flag then get arg: course
        c) COURSE=${OPTARG}
        ;;
        # if any illegal flag then display usage
        *) usage 2
        ;;
    esac
done

# if no flag then display usage
[ -z $1 ] && { usage 2; }


if [[ $TO_MOUNT -eq 1 ]]                # if -m flag
then
    if [[ $COURSE == "" ]]              # -c arg not provided
    then
        mount_all
    else                                # -c arg provided
        mount_course $COURSE 
    fi
elif [[ $TO_MOUNT -eq 0 ]]              # if -u flag
then
    if [[ $COURSE == "" ]]              # -c arg not provided
    then
        unmount_all
    else                                # -c arg provided
        unmount_course $COURSE 
    fi
else 
    usage 2                              # if TO_MOUNT=-1 then display usage
fi
