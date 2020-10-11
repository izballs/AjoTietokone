#include "mygps.h"
#include "libgpsmm.h"
#include <QDebug>
#include <QObject>
#include <math.h>
#include <QGeoCoordinate>
#include <gpsreader.h>
#include <QtMath>
#include <radio.h>
*Mygps::Mygps()
{
    m_gpsreader = new Gpsreader();
    connect(m_gpsreader, SIGNAL(coordinateChanged(QGeoCoordinate)), this, SLOT(setCoordinate(QGeoCoordinate)));

    m_thread = new QThread();
    connect(m_thread, SIGNAL(started()), m_gpsreader, SLOT(updateCoordinate()));
    m_gpsreader->moveToThread(m_thread);
}

void Mygps::startReading(){
    if(!m_thread->isRunning()){
        m_gpsreader->run = true;
        m_thread->start();
    }
}

void Mygps::stopReading(){
    if(m_thread->isRunning()){
        m_gpsreader->run = false;
        m_thread->exit();
    }
}

void Mygps::setCoordinate(QGeoCoordinate c){
    m_coordinate = c;
    emit coordinateChanged(c);
}

double Mygps::calculateDistance(QGeoCoordinate from, QGeoCoordinate to){
    double flong, flat, tlong, tlat;
    flong = from.longitude();
    flat = from.latitude();
    tlong = to.longitude();
    tlat = to.latitude();

    double dlat = .01745329 * (tlat - flat);
    double dlong = .01745329 * (tlong - flong);
    tlat = tlat * .01745329;
    flat = flat * .01745329;
    double a = qSin(dlat/2) * qSin(dlat/2) +
        qSin(dlong/2) * qSin(dlong/2) * qCos(tlat) * qCos(flat);
    double c = 2 * qAtan2(qSqrt(a), qSqrt(1-a));
    double d = 3975 * c;
    return (d * 3600) * 1.6;
}

QGeoCoordinate Mygps::getCoordinate(){
    return m_coordinate;
}
