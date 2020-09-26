#!/bin/bash
show_help()
{
    echo ------------------------------------------------------
    echo USAGE:
    echo ./build.sh docker_host image_name zm_version
    echo    -docker_host: ip of docker host [127.0.0.1 or others]
    echo    -zm_version: 1.30, 1.32, 1.34, master
    echo
    echo example:
    echo    ./build.sh 192.168.2.96 1.34
    echo ------------------------------------------------------
    echo
}

num_of_params=2
docker_host=$1
zm_version=$2

#checks number of parameters
if [ "$#" -ne $num_of_params ]; then
    echo "Illegal number of parameters."
    echo
    show_help
    exit 1
fi

#-------chnge to your needs-------------------------
default_repo="arturol76"
default_image="zoneminder"
default_tag="latest"
#---------------------------------------------------

echo

echo building image...
read -p "which repo? [$default_repo]: " repo
repo=${repo:-$default_repo}
read -p "which image? [$default_image]: " image
image=${image:-$default_image}
read -p "which tag? [$default_tag]: " tag
tag=${tag:-$default_tag}

echo building image "$repo/$image:$tag"...
docker -H $docker_host build -t $repo/$image:$tag --build-arg ZM_VERS=$zm_version .
#docker -H $docker_host build -t $repo/$image:$tag --build-arg ZM_VERS=$2 .

read -p "Do you want to push image to docker repository? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo

    echo pushing to $repo/$image:$tag...
    docker -H $docker_host push $repo/$image:$tag

    read -p "Do you want to tag it also with 'latest'? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then 
        echo pushing to $repo/$image:latest...
        docker -H $docker_host tag $repo/$image:$tag $repo/$image:latest
    else echo; fi
  
else
    echo
fi

exit 0