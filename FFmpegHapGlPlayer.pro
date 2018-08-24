# Setup
TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

# Turn this off to skip runtime info log
DEFINES += LOG_RUNTIME_INFO

# Sources
HEADERS += \
    src/HAPAvFormatOpenGLRenderer.h \
    src/hap/hap.h \
    src/glad/glad.h

SOURCES += \
    src/HAPAvFormatOpenGLRenderer.cpp \
    src/main.cpp \
    src/hap/hap.c \
    src/glad/glad.c

EXECUTABLE_PATH = $${OUT_PWD}/$${TARGET}

# Copy shaders folder next to executable
QMAKE_POST_LINK += cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};

mac {
    # Dependencies pathes
    FFMPEGPATH =   $$_PRO_FILE_PWD_/dependencies/Mac/x86_64/ffmpeg
    INCLUDEPATH += $${FFMPEGPATH}/include

    SNAPPY_PATH =  $$_PRO_FILE_PWD_/dependencies/Mac/x86_64/snappy
    INCLUDEPATH += $${SNAPPY_PATH}/include

    SDL_PATH =     $$_PRO_FILE_PWD_/dependencies/Mac/x86_64/SDL2

    # FFMPEG
    FFMPEGLIBPATH = $${FFMPEGPATH}/lib
    LIBS += $${FFMPEGLIBPATH}/libavcodec.a
    LIBS += $${FFMPEGLIBPATH}/libavdevice.a
    LIBS += $${FFMPEGLIBPATH}/libavfilter.a
    LIBS += $${FFMPEGLIBPATH}/libavformat.a
    LIBS += $${FFMPEGLIBPATH}/libavutil.a
    LIBS += $${FFMPEGLIBPATH}/libswresample.a
    LIBS += $${FFMPEGLIBPATH}/libswscale.a
    LIBS += -framework VideoDecodeAcceleration
    LIBS += -framework AudioToolbox
    LIBS += -framework CoreFoundation
    LIBS += -framework CoreVideo
    LIBS += -framework CoreMedia
    LIBS += -framework VideoToolbox
    LIBS += -framework Security
    LIBS += -lz
    LIBS += -lbz2
    LIBS += /usr/lib/libiconv.dylib
    LIBS += /usr/lib/liblzma.dylib

    # SDL
    SDL_LIB_PATH = $${SDL_PATH}/lib/
    INCLUDEPATH += $${SDL_LIB_PATH}/SDL2.framework/Headers
    QMAKE_LFLAGS += -F$${SDL_LIB_PATH}
    LIBS += -framework SDL2
    QMAKE_POST_LINK += install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 $${SDL_LIB_PATH}/SDL2.framework/Versions/A/SDL2 $${EXECUTABLE_PATH};

    # Snappy
    SNAPPY_LIB_PATH = $${SNAPPY_PATH}/lib
    LIBS += $${SNAPPY_LIB_PATH}/libsnappy.dylib
    QMAKE_POST_LINK += install_name_tool -change @rpath/libsnappy.dylib $${SNAPPY_LIB_PATH}/libsnappy.dylib $${EXECUTABLE_PATH};

    # OpenGL
    LIBS += -framework OpenGL
}

windows {
    # Dependencies pathes
    FFMPEGPATH =   $$_PRO_FILE_PWD_/dependencies/Windows/x86_64/ffmpeg
    INCLUDEPATH += $${FFMPEGPATH}/include

    SNAPPY_PATH =  $$_PRO_FILE_PWD_/dependencies/Windows/x86_64/snappy
    INCLUDEPATH += $${SNAPPY_PATH}/include

    SDL_PATH =     $$_PRO_FILE_PWD_/dependencies/Windows/x86_64/SDL2

    # FFMPEG
    FFMPEGLIBPATH = $${FFMPEGPATH}/lib
    LIBS += $${FFMPEGLIBPATH}/avcodec-lav.lib
    LIBS += $${FFMPEGLIBPATH}/avformat-lav.lib
    LIBS += $${FFMPEGLIBPATH}/avutil-lav.lib

    # SDL
    SDL_LIB_PATH = $${SDL_PATH}/lib/
    INCLUDEPATH += $${SDL_LIB_PATH}/include
    LIBS += $${SDL_LIB_PATH}/SDL2.lib $${SDL_LIB_PATH}/SDL2main.lib

    # Snappy
    SNAPPY_LIB_PATH = $${SNAPPY_PATH}/lib
    LIBS += $${SNAPPY_LIB_PATH}/snappy.lib

    # OpenGL
    LIBS += -lopengl32
}

QMAKE_POST_LINK += echo cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};
QMAKE_POST_LINK += cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};

