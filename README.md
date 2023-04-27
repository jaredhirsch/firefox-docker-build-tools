# docker-firefox-build-tools

This repo contains Dockerfiles that can be used to build Firefox, as well as
older versions of Firefox, which have backwards-incompatible dependencies
that can be tedious to change in a local development environment.

## Getting Started

0. Install platform-specific stuff (see below)
1. Install Docker on your system
2. Clone this repo
3. In this repo's directory, build the image: `docker build . -f Dockerfile`
4. Get the image's ID: `docker image ls` (it'll be an 11-char hash)
5. Enable x sharing: `xhost +local`
5. Run the image in a container: `docker run -i -t 8e46a80521b /bin/bash` (replace `8e46a80521b` with your image's ID)
6. Inside the container, configure the build: `./mach configure --without-wasm-sandboxed-libraries`
7. After configure runs, build Firefox: `./mach build`

TODO: figure out how to forward the display session and actually run Firefox locally.

Note, once you have actually gotten to step 6, your image contains a copy of
mozilla-central, so you can develop here, or run mozregression, etc.

# Platform-specific notes

## Running on macos

### Preliminary steps

To actually see the Firefox UI, you'll need to install XQuartz (these instructions come from [https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088], inlined here to simplify life):

1. Install XQuartz via brew

    `$ brew install --cask xquartz`
 
2. Logout and login of your Mac to activate XQuartz as default X11 server

3. Start XQuartz

    `$ open -a XQuartz`

4. Go to Security Settings and ensure that "Allow connections from network clients" is on
    
5. Restart your Mac and start XQuartz again`

    `$ open -a XQuartz`

6. Check if XQuartz is setup and running correctly
    
    `$ ps aux | grep Xquartz`

7. Ensure that XQuartz is running similar to this: `/opt/X11/bin/Xquartz :0 -listen tcp`
    
    :0 means the display is running on display port 0.
    Important is that its not saying `–nolisten tcp` which would block any X11 forwarding to the X11 display.

8. Allow X11 forwarding via xhost

    `$ xhost +`
    
    This allows any client to connect. If you have security concerns you can append an IP address for a whitelist mechanism.
	
	Alternatively, if you want to limit X11 forwarding to local containers, you can limit clients to localhost only via
    
	`$ xhost +localhost`
	
	Be ware: You will always have to run `xhost +` after a restart of X11 as this is not a persistent setting.

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

### Preliminary steps

Allow your local x session to be forwarded: `xhost +` (or `xhost +localhost` to limit forwarding to local containers)

## Running on windows

TODO.

# License

MPLv2
