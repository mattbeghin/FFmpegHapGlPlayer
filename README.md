# FFmpegHapGlPlayer

Very simple cross-platform code to playback a HAP video file using FFMPEG for demuxing and HapDecode/OpenGL for decoding.
It handles Hap, Hap Alpha, HapQ & HapQ+Alpha.

The idea in this project is to demonstrate how to:
- demux a HAP video file using FFmpeg / libavformat
- decompress the snappy compression using HapDecode
- send the compressed DXT buffer to an OpenGL texture (or two if HapQ+Alpha but this format is not yet supported in FFMPEG...)
- render the texture using OpenGL (with a specific shader in case of HapQ)

It uses SDL2 to create an OpenGL window.

I've been searching for how to do this process and couldn't find a simple sample, so here it is.
As it's only to demonstrate the process, it ignores any audio track, and I took some shortcuts (freeing resources properly, SDL_Delay call etc.), so the code is small enough to focus on demux->HapDecode->texture(s)->shader->display.
Any suggestion is welcome.

# Linux 

# FIXME
Only clang can compile the binary. Install clang is mandatory (apt-cache search clang to choose the one you need)
+ don't forget to install libsnappy, libblocksruntime  and libdispatch

To make the build you'll have to hack the Makefile :

1. replace gcc and g++ with clang
2. add -fblocks in CFLAGS and CXXFLAGS

e.g. on LinuxMint : 
sudo apt-get install libdispatch0 libdispatch-dev libsnappy-dev libsnappy1v5 libblocksruntime-dev libblocksruntime0


