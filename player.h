#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QtMultimedia>
#include <QMediaPlaylist>
#include <QMediaPlayer>
#include <QSettings>
#include <QRadioTuner>
#include <QMap>
#include <radio.h>

class Player : public QObject
{
Q_OBJECT

    Q_PROPERTY(QString m_title READ getTitle WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString m_author READ getAuthor WRITE setAuthor  NOTIFY authorChanged)
    Q_PROPERTY(int volumeState READ getVolumeState WRITE setVolumeState NOTIFY volumeStateChanged)
    Q_PROPERTY(int m_state READ getState WRITE setState NOTIFY stateChanged)

public:
    Player();

    Q_INVOKABLE QStringList getPlaylist();
    Q_INVOKABLE QStringList getSources();
    Q_INVOKABLE void setSource(QString q);
    Q_INVOKABLE void removeSource(int index);
    void createPlaylist();

    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void prev();

    Q_INVOKABLE int songCount();
    Q_INVOKABLE int playbackState();
    Q_INVOKABLE QString itemSource(int index);
    Q_INVOKABLE int currentIndex();

    Q_INVOKABLE void nextSong(int index);

    Q_INVOKABLE QString currentAuthor();
    Q_INVOKABLE QString currentTitle();

    Q_INVOKABLE QString getAuthor();
    Q_INVOKABLE QString getTitle();

    Q_INVOKABLE void setTitle(QString tit);
    Q_INVOKABLE void setAuthor(QString aut);

    Q_INVOKABLE void setVolumeState(int state);
    Q_INVOKABLE int getVolumeState();

 //   Q_INVOKABLE void loadSettings();
 //   Q_INVOKABLE void saveSettings();

    // Radio functions
    //Q_INVOKABLE void searchAllStations();
    //Q_INVOKABLE void stationFound(int frequency, QString stationId);
    //Q_INVOKABLE void setStation(QString stationName);
    //Q_INVOKABLE QStringList getStationList();

    Q_INVOKABLE int getState();

    Q_INVOKABLE void setState(int state);
    Q_INVOKABLE void playBluetooth(QString device);
    Q_INVOKABLE void stopBluetooth();
    Q_INVOKABLE int getBluetoothState();


signals:
    void titleChanged(QString title);
    void authorChanged(QString author);
    void volumeStateChanged(int state);
    void stateChanged();

public slots:
    void mediaChanged();

private:
    QStringList m_playlist;
    QStringList m_sources;
    QMediaPlayer *m_player = nullptr;
    QMediaPlaylist *m_playlists = nullptr;

    Radio *m_radio = nullptr;
    QMap<int, QString> stationList;

    QString m_title;
    QString m_author;

    int volumeState;
    int m_state;
    int m_bluetoothState;

};

#endif // PLAYER_H
