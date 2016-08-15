# Run zotero translator server in a container
# https://github.com/zotero/translation-server
#
# USAGE:
# $ docker build -t zts -f Dockerfile .
# $ docker run -d --rm --port 1969:1969 --name zts-container zts
#

FROM ubuntu:14.04

RUN mkdir /opt/zts
WORKDIR /opt/zts

RUN apt-get update \
    && apt-get install -y make wget firefox

COPY . .

# See makefile for variables, e.g.
# make SDK_VERSION=45.0 build
RUN make build

RUN make clean-sdk

ENTRYPOINT build/run_translation-server.sh

