VERSION = 41.0.2
ARCHITECTURE = linux-x86_64
TARBALL = xulrunner-$(VERSION).en-US.$(ARCHITECTURE).sdk.tar.bz2

xulrunner-sdk:
	wget "https://ftp.mozilla.org/pub/xulrunner/releases/$(VERSION)/sdk/$(TARBALL)"
	tar xf $(TARBALL)
