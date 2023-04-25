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
# 1.2 Install Mercurial (note: just using the distro's mercurial
# (note 2: also installing git because I like git)
# note 3: pre-installing rust to dodge around some weird problem with
#         unattended rustup setup via bootstrap
# note 4: I think we also aren't getting all the llvm / clang stuff via bootstrap...
# note 5: bootstrap can't find pkg-config. So install it via apt, too.
RUN apt-get install -y curl python3 python3-pip mercurial git llvm clang pkg-config

# to avoid bootstrap.py problems, just install rust via rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# 2. Bootstrap a copy of the Firefox source code
RUN curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
# Note: run bootstrap unattended.
RUN python3 bootstrap.py --vcs=git --application-choice=browser --no-interactive

# 3. Build
WORKDIR mozilla-unified
# CMD hg up -C central
# CMD hg up central
CMD git fetch origin
CMD git branch -t central bookmarks/central
CMD ./mach build
