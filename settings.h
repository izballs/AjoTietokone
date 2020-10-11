#ifndef SettingsQ_H
#define SettingsQ_H

#include <QSettings>
#include <QObject>

class SettingsQ : public QSettings{
    Q_OBJECT

    Q_PROPERTY(bool ac READ ac WRITE setAc NOTIFY acChanged)
    Q_PROPERTY(QString wallpaper READ wallpaper WRITE setWallpaper NOTIFY wallpaperChanged)
    Q_PROPERTY(int blowState READ blowState WRITE setBlowState NOTIFY blowStateChanged)
    Q_PROPERTY(int volumeState READ volumeState WRITE setVolumeState NOTIFY volumeStateChanged)
    Q_PROPERTY(int temperatureState READ temperatureState WRITE setTemperatureState NOTIFY temperatureStateChanged)
    Q_PROPERTY(QStringList musicSources READ musicSources WRITE setMusicSources NOTIFY musicSourcesChanged)


public:
    SettingsQ(QObject *parent = 0);

    Q_INVOKABLE void setAc(bool state);
    Q_INVOKABLE void setWallpaper(QString source);
    Q_INVOKABLE void setBlowState(int state);
    Q_INVOKABLE void setVolumeState(int state);
    Q_INVOKABLE void setTemperatureState(int state);
    Q_INVOKABLE void setMusicSources(QStringList sources);

signals:
    void acChanged();
    void wallpaperChanged();
    void blowStateChanged();
    void volumeStateChanged();


private:
    bool ac;
    QString wallpaper;
    int blowState;
    int volumeState;
    int temperatureState;
    QStringList musicSources;
};

#endif // SettingsQ_H
