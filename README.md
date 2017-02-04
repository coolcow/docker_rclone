# farmcoolcow/rclone
[![](https://img.shields.io/badge/  FROM  -farmcoolcow/entrypoints-lightgray.svg)](https://hub.docker.com/r/farmcoolcow/entrypoints) ![](https://images.microbadger.com/badges/commit/farmcoolcow/rclone.svg) ![](https://images.microbadger.com/badges/image/farmcoolcow/rclone.svg) ![](https://images.microbadger.com/badges/license/farmcoolcow/rclone.svg)

---

## What is Rclone ?

*rsync for cloud storage*

Rclone is a command line program to sync files and directories to and from cloud storage.
More informations on [the official Rclone website](http://rclone.org/).

---

## How to use this image

This image is based on [farmcoolcow/entrypoints](https://hub.docker.com/r/farmcoolcow/entrypoints/).

The default **ENTRYPOINT** is ```rclone``` and the default **CMD** is ```--help```.

The available environment variables are:
  * ```PUID``` (default = **1000**)  
    The user id of the user created inside the docker container.
  * ```PGID``` (default = **1000**)  
    The group id of the user created inside the docker container.

  > Use the environment variables ```PUID``` and ```PGID``` to execute rclone with the **uid** and **gid** of your user. This prevents permission problems while accessing your data.

Take a look ast [the rclone command list](http://rclone.org/commands/) to see all the available commands.

---

### Create new config / Edit existing config:

* Docker command:

  ```sh
  docker run -it --rm \
    -e PUID=$(id -u $(whoami)) \
    -e PGID=$(id -g $(whoami)) \
    -v <PATH_TO_YOUR_CONF>:/home/.rclone.conf \
    farmcoolcow/rclone \
      config
  ```
  
  > Replace ```<PATH_TO_YOUR_CONF>``` with the file-path of your rclone configuration file.

---

### Sync data to your cloud storage:

* Docker command:

  ```sh
  docker run -it --rm \
    -e PUID=$(id -u $(whoami)) \
    -e PGID=$(id -g $(whoami)) \
    -v <PATH_TO_YOUR_CONF>:/home/.rclone.conf \
    -v <PATH_TO_YOUR_DATA>:/data \
    farmcoolcow/rclone \
      sync /home/data cloudstorage:
  ```
  
  > Replace ```<PATH_TO_YOUR_CONF>``` with the file-path of your rclone configuration file.  
  > Replace ```<PATH_TO_YOUR_DATA>``` with the directory-path of your data directory.

---

### Run rclone sync as a cron daemon:

  > Take a look at [farmcoolcow/rclone-cron](https://hub.docker.com/r/farmcoolcow/rclone-cron). It's an image based on this image, which does nothing more than change the default **ENTRYPOINT** to ```/entrypoint_crond.sh``` and the default **CMD** to ```-f```, and sets the environment variable ```CROND_CRONTAB``` to ```/crontab```.

  * crontab file:
  
  > Syncs your data directory with your cloud storage every two hours. Uses a lock file to prevent the execution if the previous execution is not yet finished. Creates a new unique log file in your logs directory.
  
  ```crontab
  0 */2 * * * flock -n ~/rclone.lock rclone sync --log-file /logs/rclone.$(date +%Y%m%d_%H%M%S).log /data cloudstorage: &
  ```
  
  ---
  
  * Docker command:

  ```sh
  docker run -d \
    -e PUID=$(id -u $(whoami)) \
    -e PGID=$(id -g $(whoami)) \
    -e CROND_CRONTAB=/crontab \
    -v <PATH_TO_YOUR_CONF>:/home/.rclone.conf \
    -v <PATH_TO_YOUR_DATA>:/data \
    -v <PATH_TO_YOUR_CRONTAB>:/crontab \
    -v <PATH_TO_YOUR_LOGS>:/logs \
    --entrypoint=/entrypoint_crond.sh \
    farmcoolcow/rclone \
      -f
  ```
  
  > Replace ```<PATH_TO_YOUR_CONF>``` with the file-path of your rclone configuration file.  
  > Replace ```<PATH_TO_YOUR_DATA>``` with the directory-path of your data directory.  
  > Replace ```<PATH_TO_YOUR_CRONTAB>``` with the file-path of your crontab file.  
  > Replace ```<PATH_TO_YOUR_LOGS>``` with the directory-path of your log directory.
