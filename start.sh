#!/bin/bash

VERSION="v0.0.1"
DNAME="cpu_miner"

FULL_NAME="$DNAME:$VERSION"

DEFAULT_ALGO="scrypt"
DEFAULT_DISTRO="alpine"

if [[ -z "$CPUMINER_USERNAME" ]]; then
  echo "You need to set environment variable 'CPUMINER_USERNAME':"
  echo "  export CPUMINER_USERNAME=yourUsername"
  exit 1
fi

if [[ -z "$CPUMINER_URI" ]]; then
  echo "You need to set environment variable 'CPUMINER_URI':"
  echo "  export CPUMINER_URI=\"stratum+tcp://mining.domain:port\""
  exit 2
fi

if [[ -z "$CPUMINER_PASSWORD" ]]; then
  echo "Environment variable 'CPUMINER_PASSWORD' was not set. Will not pass password parameter"
  echo "  export CPUMINER_PASSWORD=\"yourPassword\""
fi

if [[ -z "$CPUMINER_ALGORITHM" ]]; then
  echo "Environment variable 'CPUMINER_ALGORITHM' not set. Defaulting to $DEFAULT_ALGO"
  USE_CPUMINER_ALGORITHM=$DEFAULT_ALGO
else
  USE_CPUMINER_ALGORITHM=$CPUMINER_ALGORITHM
fi

if [[ -z "$DOCKER_DISTRO" ]]; then
  echo "Distro not set. Defaulting to $DEFAULT_DISTRO"
  echo "  Supported distros:"
  echo "    export DOCKER_DISTRO=\"ubuntu\""
  echo "    export DOCKER_DISTRO=\"alpine\""
  USE_DOCKER_DISTRO=$DEFAULT_DISTRO
else
  USE_DOCKER_DISTRO=$DOCKER_DISTRO
fi

if [ "$1" == "rebuild" ]; then
  echo "docker stop \$(docker images -q --format \"{{.Repository}}:{{.Tag}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker images -q --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
  echo "docker stop \$(docker ps -q --format \"{{.Image}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker ps -q --format "{{.Image}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
  echo "docker rmi \$FULL_NAME --force"
  docker rmi $FULL_NAME --force
fi

if [ "$1" == "stop" ]; then
  echo "Stopping all instances of '$DNAME'"
  echo "docker stop \$(docker images -q --format \"{{.Repository}}:{{.Tag}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker images -q --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
  echo "docker stop \$(docker ps -q --format \"{{.Image}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker ps -q --format "{{.Image}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
else
  if [ "$1" == "restart" ]; then
  echo "Restarting '$DNAME'"
    echo "docker stop \$(docker images -q --format \"{{.Repository}}:{{.Tag}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
    docker stop $(docker images -q --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
    echo "docker stop \$(docker ps -q --format \"{{.Image}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
    docker stop $(docker ps -q --format "{{.Image}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
  fi

  if [[ "$(docker images -q $FULL_NAME 2> /dev/null)" == "" ]]; then
    echo "Precaching image..."
    docker pull alpine:latest # Docker occasionally fails to pull image when building when it is not cached.
    echo "Building '$FULL_NAME'"
    # docker build --quiet -t $FULL_NAME -f ./Dockerfile .
    docker build -t $FULL_NAME --network=host -f "./Dockerfile.$USE_DOCKER_DISTRO" .
  else
    echo "Build for '$FULL_NAME' already exists. Skipping..."
  fi

  if ! docker ps --format '{{.Image}}' | grep -w $FULL_NAME &> /dev/null; then
    echo "Starting '$FULL_NAME' instance"

    docker run \
      -e CUSERNAME="$CPUMINER_USERNAME" \
      -e CPASSWORD="$CPUMINER_PASSWORD" \
      -e CURI="$CPUMINER_URI" \
      -e CALGO="$USE_CPUMINER_ALGORITHM" \
      --network=host \
      --restart unless-stopped \
       -it $FULL_NAME
  else
    echo "'$FULL_NAME' is running. Check with 'docker ps'."
  fi
fi
