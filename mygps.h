#ifndef MYGPS_H
#define MYGPS_H

#include <QObject>
#include "libgpsmm.h"
#include <QGeoCoordinate>
#include <QThread>
#include <gpsreader.h>
class Mygps : public QObject
{
Q_OBJECT
    Q_PROPERTY(QGeoCoordinate m_coordinate READ getCoordinate WRITE setCoordinate NOTIFY coordinateChanged)

public:
    *Mygps();

    Q_INVOKABLE QGeoCoordinate getCoordinate();
    Q_INVOKABLE void setCoordinate(QGeoCoordinate);
    Q_INVOKABLE void startReading();
    Q_INVOKABLE void stopReading();
    Q_INVOKABLE double calculateDistance(QGeoCoordinate, QGeoCoordinate);

signals:
    void coordinateChanged(QGeoCoordinate);


private:
    Gpsreader *m_gpsreader = nullptr;
    QThread *m_thread = nullptr;
    QGeoCoordinate m_coordinate;
};

#endif // MYGPS_H
