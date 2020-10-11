#include "player.h"
#include <QtMultimedia>
#include <QMediaPlaylist>
#include <QMediaPlayer>
#include <QDirIterator>
#include <QRadioTuner>
#include <QProcess>
#include <QAudioDeviceInfo>
#include <QDebug>
#include <QSettings>
#include <radio.h>
Player::Player()
{
    m_player = new QMediaPlayer(this);
    m_sources.append("/media/music");
    createPlaylist();
    m_player->setPlaylist(m_playlists);
    connect(m_player, QOverload<>::of(&QMediaPlayer::metaDataChanged), this, &Player::mediaChanged);
    QSettings *set = new QSettings();
    setState(set->value("playerStatus").toInt());
}

void Player::playBluetooth(QString device){
    qDebug() << "playBluetooth";
    qDebug() << device;
    device = device.right(17);
    qDebug() << device;
    device = device.replace(QString(":"), QString("_"));
    qDebug() << device;
    QString cmd = "pactl load-module module-loopback source=bluez_source." + device + ".a2dp_source sink=alsa_output.platform-soc_audio.analog-stereo";
    QProcess::execute(cmd);
    m_bluetoothState = 1;
}

void Player::stopBluetooth(){
    QProcess::execute("pactl unload-module module-loopback");
    m_bluetoothState = 0;
}

int Player::getBluetoothState(){
    return m_bluetoothState;
}

void Player::mediaChanged(){

    QMediaContent mc = m_player->currentMedia();
    QString auth = "Unknown Author";
    QString title = mc.canonicalUrl().toString();

    if(!currentAuthor().isEmpty())
        auth = currentAuthor();

    if(!currentTitle().isEmpty())
        title = currentTitle();
    qDebug() << "mediaChanged title=" << title;
    setAuthor(auth);
    setTitle(title);
}

void Player::play(){
    m_player->play();
}

void Player::pause(){
    m_player->pause();
}

void Player::next(){
    m_playlists->next();
}

void Player::prev(){
    m_playlists->previous();
}

void Player::setAuthor(QString aut){
    m_author = aut;
    emit authorChanged(aut);
}
void Player::setTitle(QString tit){
     m_title = tit;

     emit titleChanged(tit);
}

void Player::setVolumeState(int state){
    m_player->setVolume(state);
    emit volumeStateChanged(state);
}

int Player::getVolumeState(){
    return volumeState;
}

int Player::songCount(){
    return m_playlists->mediaCount();

}

QString Player::getAuthor(){
    return m_author;
}

QString Player::getTitle(){
    return m_title;
}

QString Player::currentTitle(){
    QString tit = "";
    if(m_player->metaData(QMediaMetaData::Title).toString().isEmpty()){
        if(m_player->metaData(QMediaMetaData::SubTitle).toString().isEmpty()){
            if(m_player->metaData(QMediaMetaData::AlbumTitle).toString().isEmpty()){
                QStringList t = m_player->currentMedia().canonicalUrl().toString().split("/");
                for (int i = 0; i < t.count(); i++)
                    if(t[i].contains(".mp3"))
                        tit = t[i];
            }
            else {
               tit = m_player->metaData(QMediaMetaData::AlbumTitle).toString();
            }
        }
        else {
            tit = m_player->metaData(QMediaMetaData::SubTitle).toString();
        }
    }
    else {
     tit = m_player->metaData(QMediaMetaData::Title).toString();
    }
    return tit;
}

QString Player::currentAuthor(){
    QString auth = "";
    if(m_player->metaData(QMediaMetaData::Author).toString().isEmpty()){
        if(m_player->metaData(QMediaMetaData::AlbumArtist).toString().isEmpty()){
            if(m_player->metaData(QMediaMetaData::Composer).toString().isEmpty()){
                auth = "";
            }


            else{
                qDebug() << "COMPOSER";
                auth = m_player->metaData(QMediaMetaData::Composer).toString();
        }
        }
    else{
            qDebug() << "ALBUMARTIST";
        auth = m_player->metaData(QMediaMetaData::AlbumArtist).toString();
    }
    }
    else{
        qDebug() << "Author";
    auth = m_player->metaData(QMediaMetaData::Author).toString();
}

    return auth;
}

void Player::nextSong(int index){
    int cur = m_playlists->currentIndex();
    if(index < cur){
        cur -= index;
        for(int i = 0; i < cur; i++)
            prev();

    }
    else if(index > cur){
       index -= cur;
       for(int i = 0; i < index; i++)
          next();
    }
}


int Player::currentIndex(){
    return m_playlists->currentIndex();
}

int Player::playbackState(){
    if(m_player->state() == QMediaPlayer::StoppedState){
        return 2;
    }
    else if(m_player->state() == QMediaPlayer::PlayingState){
        return 1;
    }
    return 0;
}

QString Player::itemSource(int index){
    QMediaContent dd = m_playlists->media(index);
    QString d = dd.canonicalUrl().toString();
    return d;
}

QStringList Player::getSources(){
    return m_sources;
}

void Player::setSource(QString q){
    qDebug() << q;
    m_sources.append(q);
}

void Player::removeSource(int index){
    m_sources.removeAt(index);
}

QStringList Player::getPlaylist(){
    if(m_playlist.isEmpty())
    {
        createPlaylist();
        return m_playlist;
    }
    else
        return m_playlist;
}

void Player::createPlaylist(){
    if(!m_sources.empty()){
        m_playlists = new QMediaPlaylist();
        for(int i = 0; i < m_sources.length(); i++){
QDirIterator it(m_sources.at(i), QDirIterator::Subdirectories);
while(it.hasNext()){
    QFile f(it.next());
    f.open(QIODevice::ReadOnly);
    QStringList splitted = f.fileName().split(".");
    if(splitted[splitted.length()-1] == "mp3" ){
        QStringList spli = splitted.at(0).split("/");
        QString md = "file:///" + f.fileName();
        m_playlist.append(md);
        QMediaContent mc( "file:///" + f.fileName());
        m_playlists->addMedia(mc);
      }
}
 }
    }
}


void Player::setState(int state){
    QSettings set;
    set.setValue("playerStatus", state);
    switch(state){
        case 1:
            m_state = state;
            stopBluetooth();
            m_player->play();
            break;
        case 2:
            m_state = state;
            stopBluetooth();
            m_player->stop();
            break;
        case 3:
            m_state = state;
            m_player->stop();
    }

}

int Player::getState(){
    return m_state;
}

// RADIO FUNCTIONS
/*
void Player::searchAllStations(){
    m_radio->searchAllStations();
}

void Player::stationFound(int frequency, QString stationId){
    stationList[frequency] = stationId;
}

void Player::setStation(QString stationName){
    m_radio->setFrequency(stationList.key(stationName));
}

QStringList Player::getStationList(){
    QMapIterator<int, QString> i(stationList);
    QStringList stationl;
    while(i.hasNext()){
        stationl.append(i.value());
    }
    return stationl;
}
*/
