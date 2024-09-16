#!/bin/bash

source ./scripts/settings.env

# Check if the network already exists
if ! docker network ls | grep -q "$NETWORK_NAME"; then
  echo "Network $NETWORK_NAME does not exist. Creating now..."
  docker network create "$NETWORK_NAME"
  echo "Network $NETWORK_NAME created."
else
  echo "Network $NETWORK_NAME already exists."
fi


echo "Starting KeyCloak..."

if [ ! "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME does not exist. Creating and starting now..."
    docker run -d \
        --name $CONTAINER_NAME \
        --hostname $CONTAINER_NAME \
        --network $NETWORK_NAME \
        -p 8080:8080 \
        -e KEYCLOAK_ADMIN=admin \
        -e KEYCLOAK_ADMIN_PASSWORD=admin \
        -e KEYCLOAK_FRONTEND_URL=http://localhost:8080 \
        quay.io/keycloak/keycloak:25.0.5 start-dev
    echo "Container $CONTAINER_NAME started."
else
    echo "Container $CONTAINER_NAME already exists. Starting it now..."
    docker start "$CONTAINER_NAME"
fi


