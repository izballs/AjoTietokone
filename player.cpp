#include "player.h"
#include <QtMultimedia>
#include <QMediaPlaylist>
#include <QMediaPlayer>
#include <QDirIterator>
#include <QRadioTuner>
Player::Player()
{
    m_player = new QMediaPlayer(this);
    m_sources.append("C:/musiikkia");
    createPlaylist();
    m_player->setPlaylist(m_playlists);
    connect(m_player, QOverload<>::of(&QMediaPlayer::metaDataChanged), this, &Player::mediaChanged);
    m_radio = new QRadioTuner(this);
    //m_radio->searchAllStations();
    connect(m_radio, &QRadioTuner::stationFound, this, &Player::stationFound);
    setState(2);
}

void Player::mediaChanged(){

    QMediaContent mc = m_player->currentMedia();
    QString auth = "Unknown Author";
    QString title = mc.canonicalUrl().toString();
    if(!currentAuthor().isEmpty())
        auth = currentAuthor();

    if(!currentTitle().isEmpty())
        title = currentTitle();

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
    qDebug()<< aut;
}
void Player::setTitle(QString tit){
     m_title = tit;
     emit titleChanged(tit);
     qDebug()<< tit;
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
    return m_player->metaData(QMediaMetaData::Title).toString();
}

QString Player::currentAuthor(){
    return m_player->metaData(QMediaMetaData::Author).toString();
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
    qDebug() << "createPlayList";
    qDebug() << m_sources.at(i);
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
    switch(state){
        case 1:
            m_state = state;
            m_radio->stop();
            m_player->play();
            break;
        case 2:
            m_state = state;
            m_player->stop();
            m_radio->start();
            break;
    }
}

int Player::getState(){
    return m_state;
}

// RADIO FUNCTIONS

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
