# farmcoolcow/rclone ![](https://images.microbadger.com/badges/version/farmcoolcow/rclone.svg) ![](https://images.microbadger.com/badges/commit/farmcoolcow/rclone.svg) ![](https://images.microbadger.com/badges/image/farmcoolcow/rclone.svg) ![](https://images.microbadger.com/badges/license/farmcoolcow/rclone.svg)

## What is Rclone ?

*rsync for cloud storage*

Rclone is a command line program to sync files and directories to and from cloud storage.
More informations on [the official Rclone website](http://rclone.org/).

---

## How to use this image

The default **ENTRYPOINT** is ```rclone``` and the default **CMD** is ```--help```.

The available environment variables are:
  * ```ENTRYPOINT_USER``` (default = **rclone**): the user name of the user created inside the docker container. (you don't need to change this)
  * ```ENTRYPOINT_GROUP``` (default = **rclone**): the group name of the user created inside the docker container. (you don't need to change this)
  * ```ENTRYPOINT_HOME``` (default = **/home**): the home of the user created inside the docker container. (you don't need to change this)
  * ```ENTRYPOINT_COMMAND``` (default = **rclone**): the command that is executed as an entrypoint with su-exec (*/entrypoint_su-exec.sh $ENTRYPOINT_COMMAND ...).
  * ```PUID``` (default = **1000**): the user id of the user created inside the docker container.
  * ```PGID``` (default = **1000**): the group id of the user created inside the docker container.


Use the environment variables ```PUID``` and ```PGID``` to execute rclone with the **uid** and **gid** of your user. This prevents permission problems while accessing your data.

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

  > Replace ```<PATH_TO_YOUR_CONF>``` by the file-path of your rclone configuration file.

---

### Sync data to your cloud storage:

* Docker command:

  ```sh
  docker run -it --rm \
    -e PUID=$(id -u $(whoami)) \
    -e PGID=$(id -g $(whoami)) \
    -v <PATH_TO_YOUR_CONF>:/home/.rclone.conf \
    -v <PATH_TO_YOUR_DATA>:/data
    farmcoolcow/rclone \
      sync /home/data cloudstorage:
  ```

  > Replace ```<PATH_TO_YOUR_CONF>``` by the file-path of your rclone configuration file.

  > Replace ```<PATH_TO_YOUR_DATA>``` by the directory-path of your data.
