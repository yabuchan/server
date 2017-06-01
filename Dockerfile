FROM owncloud/base:latest
MAINTAINER ownCloud DevOps <devops@owncloud.com>

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

ARG OWNCLOUD_TARBALL
ARG RICHDOCUMENTS_TARBALL
ARG RICHDOCUMENTS_CHECKSUM

RUN curl -sLo - ${OWNCLOUD_TARBALL} | tar xfj - -C /var/www/
#ADD owncloud-${VERSION}.tar.bz2 /var/www/

RUN curl -sLo richdocuments.tar.gz ${RICHDOCUMENTS_TARBALL} && \
  echo "$RICHDOCUMENTS_CHECKSUM richdocuments.tar.gz" | sha256sum -c - && \
  mkdir -p /var/www/owncloud/apps/richdocuments && \
  tar -C /var/www/owncloud/apps/richdocuments --strip-components 1 -xfz richdocuments.tar.gz && \
  rm -f richdocuments.tar.gz

RUN find /var/www/owncloud \( \! -user www-data -o \! -group www-data \) -print0 | xargs -r -0 chown www-data:www-data

LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url="https://github.com/owncloud-docker/server.git"
LABEL org.label-schema.name="ownCloud Server"
LABEL org.label-schema.vendor="ownCloud GmbH"
LABEL org.label-schema.schema-version="1.0"
