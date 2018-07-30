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
    void renderFrame(AVPacket* packet);

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
};

#endif // HAPAVFORMATOPENGLRENDERER_H
