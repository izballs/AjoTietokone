#include "settings.h"

Settings::Settings(QObject* parent) :
  QSettings(parent) {
}

Settings::~Settings() {
}


void Settings::setAc(bool state){
    ac = state;
}

void Settings::setWallpaper(QString source){
    wallpaper = source;
}

void Settings::setBlowState(int state){
    blowState = state;
}

void Settings::setVolumeState(int state){
    volumeState = state;
}

void Settings::setTemperatureState(int state){
    temperatureState = state;
}

void Settings::setMusicSources(QStringList sources){
   musicSources = sources;
}
