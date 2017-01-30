#!/bin/sh

# default PUID if not set
DEFAULT_PGID=1000
# default PGID if not set
DEFAULT_PUID=1000

ENTRYPOINT_USER=$1
ENTRYPOINT_GROUP=$2
ENTRYPOINT_HOME=$3
ENTRYPOINT_COMMAND=$4
shift 4
ENTRYPOINT_PARAMS=$@

# set default GroupID and default UserID if not already set
if [ -z $PGID ]; then PGID=$DEFAULT_PGID; fi
if [ -z $PUID ]; then PUID=$DEFAULT_PUID; fi


# does a group with PGID already exist ?
EXISTING_GROUP=$(getent group $PGID | cut -f1 -d ':')
if [ ! -z $EXISTING_GROUP ]; then
  # change name of the existing group
  groupmod -n $ENTRYPOINT_GROUP $EXISTING_GROUP
else
  # create new group with PGID
  addgroup -g $PGID $ENTRYPOINT_GROUP  
fi  

# does a user with PUID already exist ?
EXISTING__USER=$(getent passwd $PUID | cut -f1 -d ':')
if [ ! -z $EXISTING__USER ]; then 
  # change login, home, shell and primary group of the existing user
  usermod -l $ENTRYPOINT_USER -d $ENTRYPOINT_HOME -s /bin/sh -g $PGID $EXISTING__USER
else
  # create new user with PUID, GROUP and HOME
  adduser -u $PUID -G $ENTRYPOINT_GROUP -h $ENTRYPOINT_HOME -D $ENTRYPOINT_USER  
fi  

# create user, group, and home
chown $ENTRYPOINT_USER:$ENTRYPOINT_GROUP $ENTRYPOINT_HOME

# exec ENTRYPOINT_COMMAND as user
su-exec $ENTRYPOINT_USER $ENTRYPOINT_COMMAND $ENTRYPOINT_PARAMS
