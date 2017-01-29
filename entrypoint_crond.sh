#!/bin/sh

PARAMS=$@

entrypoint.sh rclone rclone /home true

crond $PARAMS
