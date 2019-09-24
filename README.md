## Zoneminder Docker
Current version: 
* base image: phusion 0.10.2
* zone minder: 1.33.14
* zmeventnotification server: 4.2.5
* PHP version: 7.1

### About
A fork from dlandon/zoneminder with some changes:
* use arturol76/phusion-baseimage (phusion 0.10.2 with SSH enabled) instead of dlandon/baseimage
* zoneminder version is chosen at build time via ARG (look at build.sh)
* zmeventnotification files are downloaded from the git repo at build time
* nano editor
* use letsencrypt keys if env variable LETSENCRYPT_DOMAIN is set (see below)

### Build
`./build.sh docker_ip zm_version`
* docker_ip: ip of docker host (127.0.0.1 or others)
* zm_version: zoneminder version. Valid values: 1.30, 1.32, master

example:
`./build.sh 192.168.2.96 master`

### Run

### Usage
To access the Zoneminder gui, browse to: `https://<your host ip>:8443/zm`
The zmNinja Event Notification Server is accessed at port `9000`.

### Letsencrypt
Mount the letsencrypt volume into the docker with:
    `-v letsencrypt_volume:"/letsencrypt":ro`
and specifying the environment variable:
    `-e LETSENCRYPT_DOMAIN="arturol76.net"`

At each restart, the script will copy letsencrypt keys as follows:
`cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/fullchain.pem /config/keys/cert.crt`
`cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/privkey.pem /config/keys/cert.key`

### Change Log
2019-09-19
- 1st version.
