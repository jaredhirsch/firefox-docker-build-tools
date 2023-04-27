# docker-firefox-build-tools

This repo contains Dockerfiles that can be used to build Firefox, as well as
older versions of Firefox, which have backwards-incompatible dependencies
that can be tedious to change in a local development environment.

## Getting Started

1. Install Docker on your system
2. Clone this repo
3. In this repo's directory, build the image: `docker build . -f Dockerfile`
4. Get the image's ID: `docker image ls` (it'll be an 11-char hash)
5. Run the image in a container: `docker run -i -t 8e46a80521b /bin/bash` (replace `8e46a80521b` with your image's ID)
6. Inside the container, configure the build: `./mach configure --without-wasm-sandboxed-libraries`
7. After configure runs, build Firefox: `./mach build`

TODO: figure out how to forward the display session and actually run Firefox locally.

Note, once you have actually gotten to step 6, your image contains a copy of
mozilla-central, so you can develop here, or run mozregression, etc.

# Platform-specific notes

## Running on macos

### Out of space errors

By default, Docker on Mac stores everything in one file with a 64GB limit. It's
quite easy to go over this limit when trying to get an image to build, along
with actually fetching all the dependencies and all the code in m-c.

To make this file larger, open Docker Desktop > Resources, then adjust the
Virtual disk limit slider from the 64GB default to something bigger. 128GB
seems to work for me.

To periodically clear the stuff in this file, do `docker system prune -a -f`
at the command line.

## Running on linux

This image builds successfully in ubuntu 22.04.

## Running on windows

TODO.

# License

MPLv2
