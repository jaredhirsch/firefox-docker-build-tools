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
RUN apt-get install curl python3 python3-pip

# 1.2 Install Mercurial
RUN python3 -m pip install --user mercurial

# 2. Bootstrap a copy of the Firefox source code¶
RUN curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
RUN python3 bootstrap.py

# 3. Build
WORKDIR mozilla-unified
RUN hg up -C central
RUN ./mach build

