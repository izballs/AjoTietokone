#include "gpsreader.h"
#include <QDebug>
Gpsreader::Gpsreader()
{

}

void Gpsreader::updateCoordinate(){


    gpsmm gps_rec("localhost", DEFAULT_GPSD_PORT);
    if (gps_rec.stream(WATCH_ENABLE|WATCH_JSON) == nullptr) {
        qDebug() << "No GPSD running.\n";

    }
    qDebug() << "GPSD Running";
    for (;;) {
        qDebug() << "inside GPSD for";
        struct gps_data_t* newdata;

        if (!gps_rec.waiting(50000000))
          continue;

        if ((newdata = gps_rec.read()) == nullptr) {
            qDebug() << "Read error.\n";

        } else {
                if(run){
                QGeoCoordinate coordinate;
                coordinate.setLatitude(newdata->fix.latitude);
                coordinate.setLongitude(newdata->fix.longitude);
                coordinate.setAltitude(newdata->fix.altitude);

                    setCoordinate(coordinate);
                    emit coordinateChanged(coordinate);
                qDebug() << m_coordinate;
            }
        }
    }
}

void Gpsreader::setCoordinate(QGeoCoordinate c){
    m_coordinate = c;
}

QGeoCoordinate Gpsreader::getCoordinate(){
    return m_coordinate;
}
