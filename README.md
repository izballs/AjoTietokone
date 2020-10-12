# AjoTietokone - ProjectKIT
Tarkoituksena luoda raspberry pi:llä autoon radion tilalle käyttöliittymä autoon. Vika luku ja ajoneuvon tietojen haku, ilmastoinnin hallinta, median soitto ja navigointi tapahtuisi kaikki yhden kosketusnäytön kautta.

## Käyttöliittymän rakenne

Käyttöliittymä toimii pyyhkäisy eleillä ja onkin suunniteltu kosketusnäyttö mielessä.

```
 ____________ ____________ ____________
|------------|------------|------------|
|-Navigointi-|-NettiRadiot|------------|
|--OsoiteHaku|-Youtube----|---??????---|
|------------|-?Spotify?--|------------|
|------------|------------|------------|
|____________|____________|____________|
 ____________ ____________ ____________
|------------|------------|------------|
|-Navigointi-|-Media------|-ODB Tiedot-|
|--Kartta----|--Nopeus----|---?????----|
|------------|-Polttoaine-|------------|
|------------|------------|------------|
|____________|____________|____________|
 ____________ ____________ ____________
|------------|------------|------------|
|-Navigointi-|-KanavaLista|------------|
|-Tallennetut|-Soittolista|---??????---|
|-Sijainnit--|------------|------------|
|------------|------------|------------|
|____________|____________|____________|
```
![MediaMenu](https://izba.ovh/img/AjoTietokoneMediaMenu.gif)  
![Settings](https://izba.ovh/img/AjoTietokoneSettings.gif)
