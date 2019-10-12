#!/bin/bash
show_help()
{
    echo ------------------------------------------------------------------
    echo Runs "docker_image" on the target "docker_ip" host.
    echo Container name is specified by "container_name".
    echo Container will expose SSH service on port "docker_port".
    echo
    echo USAGE:
    echo ./run.sh docker_ip container_name docker_image port_https port_zmes port_ssh
    echo
    echo EXAMPLE:
    echo ./run.sh 192.168.2.96 zm3 arturol76/zoneminder:latest 2443 2900 2022
    echo ./run.sh 192.168.2.96 zm2 arturol76/zoneminder:latest 3443 3900 3022
    echo ------------------------------------------------------------------
    echo
}

num_of_params=6
docker_host=$1
container_name=$2
docker_image=$3
port_https=$4
port_zmes=$5
port_ssh=$6

#checks number of parameters
if [ "$#" -ne $num_of_params ]; then
    echo "Illegal number of parameters."
    echo
    show_help
    exit 1
fi

pull()
{
    read -p "Do you want to pull image? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo pulling image...
        docker -H $docker_host pull $docker_image
    else
        echo
    fi
}

stop()
{
    if [ "$(docker -H $docker_host ps -a | grep $container_name)" ]; then
        echo container $docker_host already exists

        echo stopping it...
        docker -H $docker_host stop $container_name

        echo removing it...
        docker -H $docker_host rm $container_name
    fi
}

# create your container
create()
{
    echo creating the container...
    docker -H $docker_host create \
        --restart always \
        --privileged="true" \
        -p $port_https:443/tcp \
        -p $port_zmes:9000/tcp \
        -p $port_ssh:22/tcp \
        -e TZ="Europe/Rome" \
        -e SHMEM="50%" \
        -e PUID="99" \
        -e PGID="100" \
        -e LETSENCRYPT_DOMAIN="arturol76.net" \
        -v ${container_name}_config:"/config":rw \
        -v ${container_name}_data:"/var/cache/zoneminder":rw \
        -v ${container_name}_ssh:"/root/.ssh":rw \
        -v letsencrypt-dns_etc:"/letsencrypt":ro \
        --name $container_name \
        $docker_image
}

# start container
start()
{
    echo starting the container...
    docker -H $docker_host start \
        $container_name
}

echo creating volumes...
docker -H $docker_host volume create ${container_name}_config
docker -H $docker_host volume create ${container_name}_data
docker -H $docker_host volume create ${container_name}_ssh

copy_config()
{
    read -p "Do you want to download and copy config? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo copying config into container...
        docker -H $docker_host cp ./conf/zmeventnotification/zmeventnotification.ini $container_name:/config/zmeventnotification.ini
        docker -H $docker_host cp ./conf/zmeventnotification/objectconfig.ini $container_name:/config/hook/objectconfig.ini
        docker -H $docker_host cp ./conf/known_faces/. $container_name:/config/hook/known_faces
        docker -H $docker_host cp ./conf/init/. $container_name:/etc/my_init.d
        
        #NOTE: 1st run will
        #cp -r /config/hook/models /var/lib/zmeventnotification/models
        #cp -p /config/hook/objectconfig.ini /etc/zm/ 2>/dev/null
        #cp /config/zmeventnotification.ini /etc/zm/
        #cp -r /config/hook/known_faces /var/lib/zmeventnotification/known_faces
        #cp -p /config/hook/detect* /usr/bin/ 2>/dev/null
    else
        echo
    fi
}

pull
stop
create
copy_config
start
exit 0



