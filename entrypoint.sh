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

_GROUP=$(getent group $PGID | cut -f1 -d ':')
_USER=$(getent passwd $PUID | cut -f1 -d ':')

# does a group with PGID already exist ?
if [ ! -z $_GROUP ]; then
  # change name of the existing group
  groupmod -n $GROUP $_GROUP
else
  # create new group with PGID
  addgroup -g $PGID $GROUP  
fi  

# does a user with PUID already exist ?
if [ ! -z $_USER ]; then 
  # change login, home, shell and primary group of the existing user
  usermod -l $USER -d $HOME -s /bin/sh -g $PGID $_USER
else
  # create new user with PUID, GROUP and HOME
  adduser -u $PUID -G $GROUP -h $HOME -D $USER  
fi  

# create user, group, and home
chown $USER:$GROUP $HOME

# exec command as user
su-exec $USER $COMMAND $PARAMS
