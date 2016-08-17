#!/bin/bash
set -e

SDK_VERSION=${SDK_VERSION:-48.0}
case "$(uname -s)" in
   Darwin)
       if [[ "$(uname -m)" != 'x86_64' ]];then
           echo "Unsupported architecture '$(uname -a)'"
           exit 1
       fi
       SDK_OS='mac-x86_64'
       SDK_TARBALL_EXT="tar.bz2"
       ;;
   Linux) 
       SDK_OS="linux-$(uname -m)"
       SDK_TARBALL_EXT="tar.bz2"
       ;;
   CYGWIN*|MINGW32*|MSYS*)
       if [[ "$(uname -m)" = 'x86_64' ]];then
           SDK_OS='win64'
       else
           SDK_OS='win32'
       fi
       SDK_TARBALL_EXT="zip"
       ;;
   *) echo 'Unsupported Operating system'; exit 1 ;;
esac
SDK_TARBALL="firefox-$SDK_VERSION.$SDK_OS.sdk.$SDK_TARBALL_EXT"
SDK_URL="https://archive.mozilla.org/pub/firefox/releases/$SDK_VERSION/$SDK_TARBALL"

if [[ -e "firefox-sdk" ]];then
    rm -rf "firefox-sdk"
fi
if [[ -e "$SDK_TARBALL" ]];then
    rm -f "$SDK_TARBALL"
fi
wget --progress=bar:force "$SDK_URL"
if [[ "$SDK_TARBALL_EXT" = "tar.bz2" ]];then
    tar xf "$SDK_TARBALL"
else
    unzip "$SDK_TARBALL"
fi
rm "$SDK_TARBALL"
