# OK, here we go.
# Following along with the getting-started instructions here:
#   https://firefox-source-docs.mozilla.org/setup/linux_build.html

# Let's do this for the latest ubuntu LTS, 22.04.
# Then we'll roll it back to 2021.
FROM ubuntu:22.04
MAINTAINER Jared Hirsch "jhirsch@mozilla.com"

RUN apt-get update

# 1. System preparation
# 1.1 Install Python
# 1.2 Install Mercurial (note: just using the distro's mercurial)
# note 2: also installing git because I like git
# note 3: I think we also aren't getting all the llvm / clang stuff via bootstrap...
# note 4: bootstrap can't find pkg-config. So install it via apt, too.
RUN apt-get install -y curl python3 python3-pip mercurial git llvm clang pkg-config

# note: adding (lots) more stuff that causes the built thing to fail
# note 2: lots of other libraries mentioned here, maybe we'll eventually wind up
#         needing to include them all https://gregoryszorc.com/blog/2013/05/19/using-docker-to-build-firefox/
RUN apt-get install -y packagekit-gtk3-module libasound2-dev libdbus-glib-1-dev

# To avoid later bootstrap problems, install nodejs via NodeSource.
# This incantation comes from: https://github.com/nodesource/distributions#using-debian-as-root-4
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# Install rust directly with rustup, because bootstrap's --no-interactive
# option has a bug: user interaction is needed if bootstrap installs rust.
# (TODO file a BMO bug about this)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Add cargo to the path...
ENV PATH="/root/.cargo/bin:$PATH"
# ...so we can manually install cbindgen, because bootstrap can't seem to install it.
RUN cargo install cbindgen

# 2. Bootstrap a copy of the Firefox source code
RUN curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
# Note: run bootstrap unattended.
RUN python3 bootstrap.py --vcs=git --application-choice=browser --no-interactive

# 3. Build
# TODO for some reason it won't do any of the steps past WORKDIR
#      as part of the `docker build` step. But if I shell into the
#      image, I can run these steps manually.
WORKDIR mozilla-unified
# Use git instead of hg.
CMD git fetch origin
CMD git branch -t central bookmarks/central
# CMD hg up -C central
# CMD hg up central

# Use a separate configure step to work around endless wasm/wasi linker errors.
CMD ./mozilla-unified/mach configure --without-wasm-sandboxed-libraries

# Finally, build.
CMD ./mozilla-unified/mach build
