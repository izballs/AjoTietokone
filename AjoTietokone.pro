QT += 3dcore 3dquick quick multimedia webengine network bluetooth
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    bluetooth.cpp \
    commands.cpp \
    player.cpp \
    network.cpp \
    mygps.cpp \
    gpsreader.cpp \
    radio.cpp \
    wlanconnection.cpp \
    multitouch.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    bluetooth.h \
    commands.h \
    player.h \
    network.h \
    mygps.h \
    gpsreader.h \
    radio.h \
    wlanconnection.h \
    multitouch.h

DISTFILES += \
    networkView.qml

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../libgps/lib/ -lgps
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../libgps/lib/ -lgpsd
else:unix: LIBS += -L$$PWD/../libgps/lib/ -lgps

INCLUDEPATH += $$PWD/../libgps/include
DEPENDPATH += $$PWD/../libgps/include

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../librtlsdr/lib/ -lrtlsdr
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../librtlsdr/lib/ -lrtlsdrd
else:unix: LIBS += -L$$PWD/../librtlsdr/lib/ -lrtlsdr

INCLUDEPATH += $$PWD/../librtlsdr/include
DEPENDPATH += $$PWD/../librtlsdr/include
