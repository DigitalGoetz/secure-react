#! /bin/bash

source ./scripts/settings.env

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME