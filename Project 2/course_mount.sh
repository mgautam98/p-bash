#!/bin/bash
################################################################################
#                              course_mount.sh
# 
# Script for mounting courses with permissions for specific users
# and groups                                                                   
# 
# Dependemcy: User 'trainee', Group 'ftpaccess', bindfs
# 
# Change History
# 08/06/2021  Gautam Mishra     Initial Implementation
#                               
# 
# 
################################################################################
################################################################################
################################################################################

PROG_NAME=$0

# can be changed acc to need
DATA_DIR='./courses'
TRAINEE_DIR='./trainee'

# function for usage
usage() {
    echo "usage: $PROG_NAME [-h] [-m ] [-u course]"
    echo "$PROG_NAME  -h              To print the help message"
    echo "$PROG_NAME  -m  -c [course] For mounting a given course"
    echo "$PROG_NAME  -u  -c [course] For unmounting a given course"
    echo "If course name is ommited all courses will be (un)mounted"
    exit 1
}

courses=(
    "Linux_course/Linux_course1"
    "Linux_course/Linux_course2"
    "machinelearning/machinelearning1"
    "machinelearning/machinelearning2"
    "SQLFundamentals1"
    "SQLFundamentals2"
    "SQLFundamentals3"
)

#function to check mount exists
check_mount() {
    # Return 0 if mount exists 1 if not exists
    [ -d $1 ] && return 1 || return 0;
}

# function to check if course exists
check_course() {
    # return if course not exits
    for i in ${courses[@]}
    do
        [[ $i == $1 ]] && return 0
    done
    echo "Course does not exists"
    exit 2
} 

#function for mount a course
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
    bindfs -p 550 -u trainee -g ftpaccess $DATA_DIR/$1 $TRAINEE_DIR/$1
}

# function to mount all courses
mount_all() {
    # Loop through courses array
    # call mount_course
    for i in ${courses[@]}
    do
        mount_course $i
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
    [ $mounted -eq 0 ] && return 1    # TODO: display to user if not mounted


    # If mount exists unmount and delete directory in target folder
    umount $TRAINEE_DIR/$1

    # delete target dir
    rm -r $TRAINEE_DIR/$1
}

# function for unmount all courses
unmount_all() {
    # Loop through courses array
    # call unmount_course
    for i in ${courses[@]}
    do
        unmount_course $i
    done
}

COURSE=""
TO_MOUNT=-1 # -1 for not set

while getopts humc: flag
do
    case "${flag}" in
        # for -h flag display usage
        h)  usage
        ;;
        # if -u flag set TO_MOUNT, if already set to 1 then return
        u) [ $TO_MOUNT -ne -1 ] && usage; TO_MOUNT=0
        ;;
        # if -m flag set TO_MOUNT, if already set to 0 then return
        m) [ $TO_MOUNT -ne -1 ] && usage; TO_MOUNT=1
        ;;
        # if -m flag then get arg: course
        c) COURSE=${OPTARG}
        ;;
        # if any illegal flag then display usage
        *) usage 
        ;;
    esac
done

# if no flag then display usage
[ -z $1 ] && { usage; }


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
    usage                               # if TO_MOUNT=-1 then display usage
fi
