# https://hub.docker.com/r/adoptopenjdk/openjdk8
FROM adoptopenjdk/openjdk8:jdk8u232-b09-alpine

LABEL maintainer="eed3si9n@gmail.com"

RUN set -x \
  && apk --update add --no-cache --virtual .build-deps curl \
  && SBT_VER="1.3.4" \
  && ESUM="55cc71e4f21f2dde9ba928b6c76f12016443505b32d0c47b19adf3288f94e62f" \
  && SBT_URL="https://piccolo.link/sbt-${SBT_VER}.tgz" \
  && apk add shadow \
  && apk add bash \
  && apk add openssh \
  && apk add rsync \
  && apk add git \
  && curl -Ls ${SBT_URL} > /tmp/sbt-${SBT_VER}.tgz \
  && sha256sum /tmp/sbt-${SBT_VER}.tgz \
  && (echo "${ESUM}  /tmp/sbt-${SBT_VER}.tgz" | sha256sum -c -) \
  && mkdir /opt/sbt \
  && tar -zxf /tmp/sbt-${SBT_VER}.tgz -C /opt/sbt \
  && sed -i -r 's#run \"\$\@\"#unset JAVA_TOOL_OPTIONS\nrun \"\$\@\"#g' /opt/sbt/sbt/bin/sbt \
  && apk del --purge .build-deps \
  && rm -rf /tmp/sbt-${SBT_VER}.tgz /var/cache/apk/*

WORKDIR /opt/workspace

ENTRYPOINT /bin/bash

ENV PATH="/opt/sbt/sbt/bin:$PATH" \
    JAVA_OPTS="-XX:+UseContainerSupport -Dfile.encoding=UTF-8" \
    SBT_OPTS="-Xmx2048M -Xss2M"

RUN sbt about
