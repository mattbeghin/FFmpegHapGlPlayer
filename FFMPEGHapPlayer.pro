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
    LIBS += $${FFMPEGLIBPATH}/libavcodec.dylib
    LIBS += $${FFMPEGLIBPATH}/libavdevice.dylib
    LIBS += $${FFMPEGLIBPATH}/libavfilter.dylib
    LIBS += $${FFMPEGLIBPATH}/libavformat.dylib
    LIBS += $${FFMPEGLIBPATH}/libavutil.dylib
    LIBS += $${FFMPEGLIBPATH}/libswresample.dylib
    LIBS += $${FFMPEGLIBPATH}/libswscale.dylib
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libavcodec.56.dylib $${FFMPEGLIBPATH}/libavcodec.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libavdevice.56.dylib $${FFMPEGLIBPATH}/libavdevice.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libavfilter.5.dylib $${FFMPEGLIBPATH}/libavfilter.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libavformat.56.dylib $${FFMPEGLIBPATH}/libavformat.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libavutil.54.dylib $${FFMPEGLIBPATH}/libavutil.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libswresample.1.dylib $${FFMPEGLIBPATH}/libswresample.dylib $${EXECUTABLE_PATH};
    QMAKE_POST_LINK += install_name_tool -change /Developer/G3Tools/ffmpeg-2.8.7-build-64/lib/libswscale.3.dylib $${FFMPEGLIBPATH}/libswscale.dylib $${EXECUTABLE_PATH};

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
