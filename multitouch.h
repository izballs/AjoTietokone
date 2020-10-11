#ifndef MULTITOUCH_H
#define MULTITOUCH_H

#include <QObject>
#include <QTouchDevice>
class MultiTouch : public QObject
{
Q_OBJECT
public:
    MultiTouch();
};

#endif // MULTITOUCH_H
