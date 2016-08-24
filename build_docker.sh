#!/bin/bash

DOCKER_TAG=zotero/translation-server
SDK_VERSION=48.0.2
ZOTERO_VERSION=4.0.29.11

usage () { echo "Usage: $0 [--tag <docker-tag>] [--sdk <sdk-version>]  [--zotero <zotero-version>]"; }

while [[ "$1" = -* ]];do
    case "$1" in
        --tag) DOCKER_TAG="$2"; shift ;;
        --sdk) SDK_VERSION="$2"; shift ;;
        --zotero) ZOTERO_VERSION="$2"; shift ;;
        *) usage; exit ;;
    esac
    shift
done

if (( ${SDK_VERSION:0:2} >= 42 ));then
    SDK_DIR=firefox-sdk
else
    SDK_DIR=xulrunner-sdk
fi

declare -a cmd
cmd+=(docker build)
cmd+=(--build-arg SDK_VERSION="$SDK_VERSION")
cmd+=(--build-arg SDK_DIR="$SDK_DIR")
cmd+=(--build-arg ZOTERO_VERSION="$ZOTERO_VERSION")
cmd+=(--tag "$DOCKER_TAG:${SDK_DIR}${SDK_VERSION}zotero${ZOTERO_VERSION}")
cmd+=(.)
echo "${cmd[*]}"
exec "${cmd[@]}"
