echo ------------------------------------------------------
echo USAGE:
echo ./build.sh docker_ip image_name zm_version disable_ssh
echo    -docker_ip: ip of docker host [127.0.0.1 or others]
echo    -zm_version: 1.30, 1.32, master
echo
echo example:
echo    ./build.sh 192.168.2.96 master
echo ------------------------------------------------------
echo
default_repo="arturol76"
default_image="zoneminder"
default_tag="latest"

echo

#ZmEventNotification repo
echo cloning zmeventnotification repo...
if [ -d "./tmp" ]; then rm -Rf ./tmp; fi
if [ -d "./zmeventnotification" ]; then rm -Rf ./zmeventnotification; fi

git clone https://github.com/pliablepixels/zmeventnotification ./tmp
cp -r ./tmp/hook zmeventnotification
cp ./tmp/zmeventnotification.* zmeventnotification
cd ./zmeventnotification
rm -r dev_notes
rm .gitignore LICENSE MANIFEST.in requirements.txt
cd ..

if [ -d "./tmp" ]; then rm -Rf ./tmp; fi

echo zmeventnotification version is:
cat ./zmeventnotification/zmes_hook_helpers/__init__.py

echo building image...
read -p "which repo? [$default_repo]: " repo
repo=${repo:-$default_repo}
read -p "which image? [$default_image]: " image
image=${image:-$default_image}
read -p "which tag? [$default_tag]: " tag
tag=${tag:-$default_tag}

echo building image "$repo/$image:$tag"...
#docker -H $1 build --no-cache -t $repo/$image:$tag --build-arg ZM_VERS=$2 .
docker -H $1 build -t $repo/$image:$tag --build-arg ZM_VERS=$2 .

echo removing garbage...
if [ -d "./zmeventnotification" ]; then rm -Rf ./zmeventnotification; fi

read -p "Do you want to push image to docker repository? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo

    echo pushing to $repo/$image:$tag...
    docker -H $1 push $repo/$image:$tag

    read -p "Do you want to tag it also with 'latest'? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then 
        echo pushing to $repo/$image:latest...
        docker -H $1 push $repo/$image:latest
    else echo; fi
  
else
    echo
fi

