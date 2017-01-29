#!/bin/sh

# default PUID if not set
DGID=1000
# default PGID if not set
DUID=1000

USER=$1
GROUP=$2
HOME=$3
COMMAND=$4
shift 4
PARAMS=$@

# set default GroupID and default UserID if not already set
if [ -z $PGID ]; then PGID=$DGID; fi
if [ -z $PUID ]; then PUID=$DUID; fi

# delete user/group if PUID/PGID already exists
_USER=$(getent passwd $PUID | cut -f1 -d ':')
_GROUP=$(getent group $PGID | cut -f1 -d ':')
if [ -z $_USER ]; then deluser $_USER; fi  
if [ -z $_GROUP ]; then delgroup $_GROUP; fi  

# create user, group, and home
addgroup -g $PGID $GROUP
adduser -u $PUID -G $GROUP -h $HOME -D $USER
chown $USER:$GROUP $HOME

# exec command as user
su-exec $USER $COMMAND $PARAMS
