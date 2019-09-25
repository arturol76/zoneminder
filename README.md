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
Create the named volumes:

`docker volume create zm_config
docker volume create zm_data
docker volume create zm_ssh`

Create the container:

`docker create \
        --restart always \
        --privileged="true" \
        -p YOUR_HTTPS_PORT:443/tcp \
        -p YOUR_ZMES_PORT:9000/tcp \
        -p YOUR_SSH_PORT:22/tcp \
        -e TZ="Europe/Rome" \
        -e SHMEM="50%" \
        -e PUID="99" \
        -e PGID="100" \
        -e INSTALL_HOOK="1" \
        -e INSTALL_FACE="1" \
        -e INSTALL_TINY_YOLO="1" \
        -e INSTALL_YOLO="1" \
        -e LETSENCRYPT_DOMAIN="YOUR_DOMAIN" \
        -v zm_config:"/config":rw \
        -v zm_data:"/var/cache/zoneminder":rw \
        -v zm_ssh:"/root/.ssh":rw \
        -v letsencrypt:"/letsencrypt":ro \
        --name zm \
        arturol76/zoneminder`

Copy your own config files into the zm_config volume:

`docker cp ./conf/zmeventnotification/zmeventnotification.ini zm:/config/zmeventnotification.ini
docker cp ./conf/zmeventnotification/objectconfig.ini zm:/config/hook/objectconfig.ini
docker cp ./conf/known_faces/. zm:/config/hook/known_faces
docker cp ./conf/init/. zm:/etc/my_init.d`

Start the container:
`   docker start zm`

### Letsencrypt
To use the letsencrypt keys:
* assuming that your letsencrypt keys (fullchain.pem and cert.key) are stored in a named folder 'letsencrypt_volume', mount it into the docker with: `-v letsencrypt_volume:"/letsencrypt":ro`
* assign your domain name (ex. arturol76.net) to the environment LETSENCRYPT_DOMAIN variable: `-e LETSENCRYPT_DOMAIN="arturol76.net"`

Once started, the container will copy keys from letsecnrypt volume into the container as follows:

`cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/fullchain.pem /config/keys/cert.crt`

`cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/privkey.pem /config/keys/cert.key`

### Usage
To access the Zoneminder gui, browse to: `https://<your host ip>:8443/zm`
The zmNinja Event Notification Server is accessed at port `9000`.

### Change Log
2019-09-19
- 1st version.
