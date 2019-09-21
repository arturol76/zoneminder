#usage:
#./build.sh docker_ip image_name zm_version
#   docker_ip: ip of docker host (127.0.0.1 or others)
#   zm_version: 1.32, master
#
#example:
#   ./build.sh 192.168.2.96 arturol76/zoneminder:1.33 master

IMAGE_NAME=$2

read -p "Do you want to build image? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo

    echo building image...
    docker -H $1 build --no-cache -t $IMAGE_NAME --build-arg ZM_VERS=$3 .
else
    echo
fi

read -p "Do you want to push image to docker repository? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo

    echo pushing...
    docker -H $1 push $IMAGE_NAME
else
    echo
fi

