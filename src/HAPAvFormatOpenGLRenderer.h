#ifndef HAPAVFORMATOPENGLRENDERER_H
#define HAPAVFORMATOPENGLRENDERER_H

#include <assert.h>

#if defined(__APPLE__)
    #include <OpenGL/gl.h>
#elif defined(__WIN32__)
    #include <gl/GL.h>
#else // Linux
    #include <GL/gl.h>
#endif

extern "C"
{
    #include <libavcodec/avcodec.h>
    #include <libavformat/avformat.h>
}

class HAPAvFormatOpenGLRenderer {
public:
    HAPAvFormatOpenGLRenderer(AVCodecContext* codecCtx);
    void renderFrame(AVPacket* packet, double msTime);

private:
    int m_textureCount;
    int m_textureWidth, m_textureHeight;
    int m_codedWidth, m_codedHeight;

    // Frame buffers in RAM
    void* m_outputBuffers[2];
    size_t m_outputBufferSize[2];

    // OpenGL Textures information
    GLuint m_outputTextures[2];
    GLuint m_glInternalFormat[2];

    // Shader Program to use for rendering
    // It will depend on HAP encoding (Hap, Hap Alpha, HapQ, HapQ+Alpha)
    void createShaderProgram(unsigned int codecTag);
    GLuint m_shaderProgram;

    #ifdef LOG_RUNTIME_INFO
        class RuntimeInfoLogger {
        public:
            void onNewFrame(double msTime, int packetLength) {
                if (m_startTime==0) {
                    // Init
                    m_startTime=msTime;
                    m_lastLogTime=msTime;
                }
                // Log info each 1 second
                if (msTime > m_lastLogTime+1000) {
                    m_lastLogTime = msTime;
                    double elapsedTime = msTime - m_startTime;
                    printf("Decompressed Frames: %ld, Average Input Bitrate: %lf, Average Output Birate: %lf, Average framerate: %lf\n",m_frameCount,m_totalBytesRead*8/elapsedTime,m_totalBytesDecompressed*8/elapsedTime,m_frameCount/double((msTime-m_startTime)/1000));
                }
                m_frameCount++;
                m_totalBytesRead += packetLength;
            }
            void onHapDataDecoded(size_t outputBufferDecodedSize) {
                m_totalBytesDecompressed += outputBufferDecodedSize;
            }
        private:
            size_t m_startTime=0;
            size_t m_lastLogTime=0;
            size_t m_frameCount=0;
            size_t m_totalBytesRead=0;
            size_t m_totalBytesDecompressed=0;
        };
        RuntimeInfoLogger m_infoLogger;
    #endif
};

#endif // HAPAVFORMATOPENGLRENDERER_H
