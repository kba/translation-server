# Run zotero translator server in a container
# https://github.com/zotero/translation-server
#
# USAGE:
# $ docker build -t translation-server .
# $ docker run -d --rm --port 1969:1969 --name translation-server-container translation-server
#
# To build against a specific SDK, set the SDK_VERSION environment variable
#
# SDK_VERSION=29.0 docker build -t translation-server .
#

FROM ubuntu:14.04

ARG SDK_DIR
ARG SDK_VERSION
ARG ZOTERO_VERSION

EXPOSE 1969

ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir /opt/translation-server
WORKDIR /opt/translation-server

COPY . .

RUN apt-get update && apt-get install -y wget firefox git \
    && bash fetch_sdk \
    && git submodule init \
    && git submodule update --init --recursive; \
    if [ -n "$ZOTERO_VERSION" ];then \
        ( cd modules/zotero && git checkout "$ZOTERO_VERSION" ); \
    fi; \
    bash build.sh \
    && apt-get --purge -y remove wget firefox git \
    && find -name '.git' -exec rm -r {} \; \
    && rm -rf /var/cache/apt \
    && rm -rf /var/lib/apt/lists

ENTRYPOINT build/run_translation-server.sh
