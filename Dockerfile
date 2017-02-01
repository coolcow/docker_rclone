FROM farmcoolcow/alpine_entrypoint

MAINTAINER Jean-Michel Ruiz <mail@coolcow.org>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="rclone" \
      org.label-schema.description="Simple rclone Docker image based on alpine." \
      org.label-schema.url="https://hub.docker.com/r/farmcoolcow/rclone/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/farmcoolcow/rclone" \
      org.label-schema.vendor="coolcow.org" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

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

VOLUME $ENTRYPOINT_HOME

WORKDIR $ENTRYPOINT_HOME

ENTRYPOINT ["/entrypoint_su-exec.sh", "rclone"]

CMD ["--help"]
