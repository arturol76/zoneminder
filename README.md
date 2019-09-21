## Zoneminder Docker
(Current version: 1.32)

### About
A fork from dlandon/zoneminder.
Dockerfile changed to specify the zoneminder version at build time.

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

#### Change Log

2019-09-19
- 1st version.
