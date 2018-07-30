# FFmpegHapGlPlayer

Very simple cross-platform code to playback a HAP video file using FFMPEG for demuxing and HapDecode/OpenGL for decoding.
It handles Hap, Hap Alpha, HapQ but not HapQ+Alpha since it's not recognized by ffmpeg today (july 2018).

The idea in this project is to demonstrate how to:
 1- demux a HAP video file using FFmpeg / libavformat
 2- decompress the snappy compression using HapDecode
 3- send the compressed DXT buffer to an OpenGL texture (or two if HapQ+Alpha but this format is not yet supported in FFMPEG...)
 4- render the texture using OpenGL (with a specific shader in case of HapQ)

It uses SDL2 to create an OpenGL window.

I've been searching for how to do this process and couldn't find a simple sample, so here it is.
As it's only to demonstrate the process, it ignores any audio track, and I took some shortcuts (freeing resources properly, SDL_Delay call etc.), so the code is small enough to focus on demux->HapDecode->texture(s)->shader->display.
