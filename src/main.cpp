#include <iostream>
#include "HAPAvFormatOpenGLRenderer.h"
#include <SDL.h>

using namespace std;

int main(int argc, char** argv)
{
    // Get file path to open
    if (argc != 2) {
        cout << "Requires exactly one parameter: the file path of the movie to playback";
        return -1;
    }
    char* filepath = argv[1];

    // Initialize AV Codec / Format
    av_register_all();
    avformat_network_init();
    AVFormatContext* pFormatCtx = avformat_alloc_context();

    // Open file
    if(avformat_open_input(&pFormatCtx,filepath,NULL,NULL)!=0){
        printf("Couldn't open input stream.\n");
        return -1;
    }
    if(avformat_find_stream_info(pFormatCtx,NULL)<0){
        printf("Couldn't find stream information.\n");
        return -1;
    }
    int videoindex=-1;
    for(unsigned int i=0; i<pFormatCtx->nb_streams; i++)
        if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
            videoindex=i;
            break;
        }
    if(videoindex==-1){
        printf("Didn't find a video stream.\n");
        return -1;
    }

    AVCodecContext* pCodecCtx=pFormatCtx->streams[videoindex]->codec;
    if (pCodecCtx->codec_id != AV_CODEC_ID_HAP) {
        printf("This app only playbacks HAP movies.\n");
        return -1;
    }

    // Output Info-----------------------------
    printf("--------------- File Information ----------------\n");
    av_dump_format(pFormatCtx,0,filepath,0);

    // Initialize SDL And create window
    if(SDL_Init(SDL_INIT_VIDEO)) {
        printf( "Could not initialize SDL - %s\n", SDL_GetError());
        return -1;
    }

    //SDL 2.0 Support for multiple windows
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
    SDL_Window *window = SDL_CreateWindow("Simplest ffmpeg player's Window", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        pCodecCtx->width, pCodecCtx->height,
        SDL_WINDOW_OPENGL);
    if(!window) {
        printf("SDL: could not create window - exiting:%s\n",SDL_GetError());
        return -1;
    }
    SDL_GL_CreateContext(window);

    // Instanciate HAPAvFormatOpenGLRenderer
    HAPAvFormatOpenGLRenderer hapAvFormatRenderer(pCodecCtx);

    // Loop playing back frames until user ask to close the window
    AVPacket packet;
    bool shouldQuit = false;
    double lastFrameTimeMs = SDL_GetTicks();
    while (!shouldQuit) {
        while (!shouldQuit && av_read_frame(pFormatCtx, &packet)>=0){
            if(packet.stream_index==videoindex){
                int64_t den = pFormatCtx->streams[packet.stream_index]->time_base.den;
                int64_t num = pFormatCtx->streams[packet.stream_index]->time_base.num;
                int64_t frameDuration = av_rescale(packet.duration, AV_TIME_BASE * num, den);

                // Display new frame in openGL backbuffer
                hapAvFormatRenderer.renderFrame(&packet,lastFrameTimeMs);

                // Keep showing previous frame depending on movie FPS (see frameDurationMs below)
                double frameDurationMs = frameDuration / 1000.0;
                double frameEndTimeMs = lastFrameTimeMs + frameDurationMs;

                // Delay: remark we keep processing UI events, this is dirty
                // but this example aims at keeping the code as easy to read
                // as possible, so keep it simple
                SDL_Event event;
                while(!shouldQuit && SDL_PollEvent(&event)) {
                    if (event.type == SDL_QUIT) {
                        shouldQuit = true;
                    }
                }

                // Sleep until we reach frame end time
                while (SDL_GetTicks() < frameEndTimeMs) {
                    SDL_Delay(1);
                }
                lastFrameTimeMs = frameEndTimeMs;

                // Now swap OpenGL Backbuffer to front
                SDL_GL_SwapWindow(window);
            }
            av_free_packet(&packet);
        }

        // Loop - seek back to first frame
        av_seek_frame(pFormatCtx,-1,0,AVSEEK_FLAG_BACKWARD);
    }

    // Free resources - remark: should free OpenGL resources allocated in HAPAvFormatOpenGLRenderer
    SDL_Quit();
    avformat_close_input(&pFormatCtx);

    return 0;
}
