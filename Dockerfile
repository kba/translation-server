# Run zotero translator server in a container
# https://github.com/zotero/translation-server
# 
# USAGE:
# $ docker build -t zts -f Dockerfile .
# $ docker run -d --rm --port 1969:1969 --name zts-container zts
# 

FROM ubuntu:14.04

ENV VERSION 41.0.2
ENV ARCHITECTURE linux-x86_64
# alternatively linux-i686

WORKDIR opt

RUN apt-get update && apt-get install -y curl git firefox \
    && git clone --recursive "https://github.com/zotero/translation-server" \
    && cd translation-server \
    && curl -o xulrunner.tar.bz2 \
        "https://ftp.mozilla.org/pub/xulrunner/releases/${VERSION}/sdk/xulrunner-${VERSION}.en-US.${ARCHITECTURE}.sdk.tar.bz2" \
    && tar xf xulrunner.tar.bz2 \
    && rm xulrunner.tar.bz2 \
    && sed -i \
        -e 's,/Users/simon/Desktop/Development/FS/zotero/translators,/opt/translation-server/modules/zotero/translators,' \
        config.js \
    && ./build.sh
    && find . -name '.git' -exec rm -rf {} \;
    && apt-get remove git curl

CMD bash build/run_translation-server.sh

