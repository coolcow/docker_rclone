FROM farmcoolcow/entrypoints

MAINTAINER Jean-Michel Ruiz (coolcow) <mail@coolcow.org>

# Build-time metadata as defined at http://label-schema.org

ARG BUILD_DATE
ARG VCS_REF
ARG IMAGE_NAME
ARG VERSION="latest"

LABEL maintainer="Jean-Michel Ruiz (coolcow) <mail@coolcow.org>" \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.description="Simple rclone Docker image based on alpine." \
      org.label-schema.name="$IMAGE_NAME" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://hub.docker.com/r/$IMAGE_NAME/" \
      org.label-schema.license="GPL-3.0" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/farmcoolcow/docker_rclone" \
      org.label-schema.vendor="coolcow.org" \
      org.label-schema.version="$VERSION"


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
