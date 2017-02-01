FROM farmcoolcow/alpine_entrypoint

MAINTAINER Jean-Michel Ruiz (coolcow) <mail@coolcow.org>

# Build-time metadata as defined at http://label-schema.org

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="rclone" \
      org.label-schema.description="Simple rclone Docker image based on alpine." \
      org.label-schema.url="https://hub.docker.com/r/farmcoolcow/rclone/" \
      org.label-schema.license="GPL v3" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/farmcoolcow/docker_rclone" \
      org.label-schema.vendor="coolcow.org" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"


# Evironment variables

ENV ARCH=amd64 \
    RCLONE_VERSION=current \
    RCLONE_DOWNLOAD=http://downloads.rclone.org \
    ENTRYPOINT_USER=rclone \
    ENTRYPOINT_GROUP=rclone \
    ENTRYPOINT_HOME=/home
ENV RCLONE_ZIP=rclone-${RCLONE_VERSION}-linux-${ARCH}.zip

# install rclone

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
