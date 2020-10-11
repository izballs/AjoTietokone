
#ifndef GPSREADER_H
#define GPSREADER_H

#include <QObject>
#include "libgpsmm.h"
#include <QGeoCoordinate>
#include <QThread>
class Gpsreader : public QObject
{
Q_OBJECT
    Q_PROPERTY(QGeoCoordinate m_coordinate READ getCoordinate WRITE setCoordinate NOTIFY coordinateChanged)

public:
    Gpsreader();

    bool run = true;

public slots:
    Q_INVOKABLE void updateCoordinate();
    Q_INVOKABLE QGeoCoordinate getCoordinate();
    Q_INVOKABLE void setCoordinate(QGeoCoordinate);

signals:
    void coordinateChanged(QGeoCoordinate);


private:
    QThread m_thread;
    QGeoCoordinate m_coordinate;
};


#endif // GPSREADER_H
