#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <player.h>
#include <QtWebEngine>
#include <youtube.h>
int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<Player>("PLAYER", 1, 0, "Player");
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
