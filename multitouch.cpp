#include "multitouch.h"
#include <fcntl.h>
#include <QDebug>
MultiTouch::MultiTouch()
{
 int fd;
 fd = open("/dev/input/event0", O_RDWR | O_NOCTTY | O_NDELAY);
 if(fd == -1){
     qDebug() << "Error opening event0";

 }
 else
     qDebug() << "can read events";
}
