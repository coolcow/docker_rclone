FROM farmcoolcow/alpine_entrypoint

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

ENV ARCH=amd64
ENV RCLONE_VERSION=current
ENV RCLONE_ZIP=rclone-${RCLONE_VERSION}-linux-${ARCH}.zip
ENV RCLONE_DOWNLOAD=http://downloads.rclone.org

ENV ENTRYPOINT_USER=rclone
ENV ENTRYPOINT_GROUP=rclone
ENV ENTRYPOINT_HOME=/home

RUN apk --no-cache --update add \
      ca-certificates \
      fuse \
    && cd /tmp \
    && wget -q ${RCLONE_DOWNLOAD}/${RCLONE_ZIP} \
    && unzip /tmp/${RCLONE_ZIP} \
    && mv /tmp/rclone*/rclone /usr/bin \
    && rm -r /tmp/rclone*

WORKDIR $ENTRYPOINT_HOME

ENTRYPOINT ["/entrypoint_su-exec.sh", "rclone"]

CMD ["--help"]
