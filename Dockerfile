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

RUN apt-get update && apt-get install -y curl git fontconfig libasound2 libatk1.0-0 libc6 libcairo2 libdbus-1-3 libdbus-glib-1-2 libevent-2.0-5 libffi6 libfontconfig1 libfreetype6 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 libhunspell-1.3-0 libpango-1.0-0 libsqlite3-0 libstartup-notification0 libstdc++6 libx11-6 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrender1 libxt6 procps zlib1g \
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

