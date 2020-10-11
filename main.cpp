#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <player.h>
#include <QtWebEngine>
#include <youtube.h>
#include <bluetooth.h>
#include <commands.h>
#include <network.h>
#include <mygps.h>
#include <multitouch.h>
int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("XDG_RUNTIME_DIR", QByteArray("/home/pi/projectKIT"));
    qputenv("QTWEBENGINE_DISABLE_SANDBOX", QByteArray("1"));
    qputenv("QT_QPA_EGLFS_WIDTH", QByteArray("800"));
    qputenv("QT_QPA_EGLFS_HEIGHT", QByteArray("480"));
    qputenv("QT_DEBUG_PLUGINS", QByteArray("0"));
    qputenv("QT_QPA_PLATFORM", QByteArray("eglfs"));
    qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("155"));
    qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("86"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qmlRegisterType<Player>("PLAYER", 1, 0, "Player");
    qmlRegisterType<Bluetooth>("PLAYER", 1, 0, "Bluetooth");
    qmlRegisterType<Commands>("PLAYER", 1, 0, "Commands");
    qmlRegisterSingletonType<Network>("PLAYER", 1, 0, "Network", networkProvider);
    qmlRegisterType<Mygps>("PLAYER", 1, 0, "Mygps");
    qmlRegisterType<MultiTouch>("PLAYER", 1, 0, "MultiTouch");
    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();
    QQmlApplicationEngine engine;

    QCoreApplication::setOrganizationName("IzReallySoft");
    QCoreApplication::setOrganizationDomain("izba.ovh");
    QCoreApplication::setApplicationName("Project KIT");


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
