TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.cpp \
    hap/hap.c \
    HAPAvFormatOpenGLRenderer.cpp

HEADERS += \
    HAPAvFormatOpenGLRenderer.h \
    hap/hap.h

FFMPEGPATH = $$_PRO_FILE_PWD_/dependencies/ffmpeg
INCLUDEPATH += $${FFMPEGPATH}/include

SNAPPY_PATH = $$_PRO_FILE_PWD_/dependencies/snappy
INCLUDEPATH += $${SNAPPY_PATH}/snappy-source

SDL_PATH = $$_PRO_FILE_PWD_/dependencies/SDL2
SQUISH_PATH = $$_PRO_FILE_PWD_/dependencies/squish

EXECUTABLE_PATH = $${OUT_PWD}/$${TARGET}
#message(executable path: $${EXECUTABLE_PATH})

# Copy shaders folder next to executable
QMAKE_POST_LINK += cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};

mac {
    # FFMPEG
    FFMPEGLIBPATH = $${FFMPEGPATH}/lib/Mac/x86_64
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
    SDL_LIB_PATH = $${SDL_PATH}/lib/Mac/
    INCLUDEPATH += $${SDL_LIB_PATH}/SDL2.framework/Headers
    QMAKE_LFLAGS += -F$${SDL_LIB_PATH}
    LIBS += -framework SDL2
    QMAKE_POST_LINK += install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 $${SDL_LIB_PATH}/SDL2.framework/Versions/A/SDL2 $${EXECUTABLE_PATH};

    # Snappy
    SNAPPY_LIB_PATH = $${SNAPPY_PATH}/lib/Mac/x86_64
    LIBS += $${SNAPPY_LIB_PATH}/libsnappy.dylib
    QMAKE_POST_LINK += install_name_tool -change @rpath/libsnappy.dylib $${SNAPPY_LIB_PATH}/libsnappy.dylib $${EXECUTABLE_PATH};

    # OpenGL
    LIBS += -framework OpenGL
}

windows {
    # FFMPEG

    # SDL

    # Snappy

    # OpenGL
    LIBS += -lopengl32
}

QMAKE_POST_LINK += echo cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};
QMAKE_POST_LINK += cp -R $$_PRO_FILE_PWD_/shaders $${OUT_PWD};
