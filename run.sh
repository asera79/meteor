#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'Use: run.sh {app_name}'
    exit 1
fi
CUR_DIR=${PWD}
if [[ $CUR_DIR == /cygdrive* ]] ; then
    echo "сonverting to Windows path"
    CUR_DIR=$(cygpath -C ANSI -w "$CUR_DIR")
fi
BIND_DIR=$CUR_DIR"/"$1
echo "path to bind $BIND_DIR"
if [ ! -d "$BIND_DIR" ] ; then
    echo "create new bind dir"
    mkdir $BIND_DIR
    echo "create project in new bind dir"
    docker run --rm -v "$BIND_DIR:/opt/app/$1" -w "/opt/app" asera79/meteor create $1
fi
echo "start mongodb"
if [ ! "$(docker ps -q -f name=mongodb)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=mongodb)" ]; then
        # cleanup
        docker rm mongodb
    fi
    # run mongo container
    docker run -d -v "mongodb:/data/db" -p 27017:27017 --name mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=secret mongo
fi
echo "start meteor"
if [ ! "$(docker ps -q -f name=$1)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$1)" ]; then
        # cleanup
        docker rm $1
    fi
    # run your container
    docker run -d -v "$BIND_DIR:/opt/app/$1" -p 3000:3000 --name $1 -w "/opt/app/$1"  --link mongodb:mongodb asera79/meteor
fi
echo "docker exec -it $1 /bin/bash"

