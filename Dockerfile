FROM alpine

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

ENV ARCH=amd64
ENV RCLONE_VERSION=current
ENV RCLONE_ZIP=rclone-${RCLONE_VERSION}-linux-${ARCH}.zip
ENV RCLONE_DOWNLOAD=http://downloads.rclone.org

RUN apk --no-cache --update add ca-certificates fuse su-exec \
    && cd /tmp \
    && wget -q ${RCLONE_DOWNLOAD}/${RCLONE_ZIP} \
    && unzip /tmp/${RCLONE_ZIP} \
    && mv /tmp/rclone*/rclone /usr/bin \
    && rm -r /tmp/rclone*

WORKDIR /home

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

#                            USER      GROUP     HOME     COMMAND
ENTRYPOINT ["entrypoint.sh", "rclone", "rclone", "/home", "rclone"]

CMD ["--help"]
