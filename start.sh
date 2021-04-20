#!/bin/bash

# See: https://prohashing.com/tools/miner-configurator/

# Example:
# export CPUMINER_USERNAME=yourUsername
# CPUMINER_URI=stratum+tcp://prohashing.com:3336 -p "a=scrypt"
# ./start.sh

# Doge:
# export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
# export CPUMINER_PASSWORD="a=scrypt,c=dogecoin,n=RPi1"

# Scrypt:
# export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
# export CPUMINER_PASSWORD="a=scrypt,d=16384,n=RPi1"

# Ethereum:
# export CPUMINER_URI="stratum+tcp://prohashing.com:3339"
# export CPUMINER_PASSWORD="a=ethash,c=ethereum,n=RPi1"

# Other:
# export CPUMINER_URI="stratum+tcp://prohashing.com:3336"
# export CPUMINER_PASSWORD="a=equihash,n=RPi1"

VERSION="v0.0.1"
DNAME="cpu_miner"

FULL_NAME="$DNAME:$VERSION"

DEFAULT_ALGO="scrypt"

if [[ -z "$CPUMINER_USERNAME" ]]; then
  echo "You need to set environment variable 'CPUMINER_USERNAME'"
  exit 1
fi

if [[ -z "$CPUMINER_URI" ]]; then
  echo "You need to set environment variable 'CPUMINER_URI'"
  exit 2
fi

if [[ -z "$CPUMINER_PASSWORD" ]]; then
  echo "Environment variable 'CPUMINER_PASSWORD' was not set. Will not pass password parameter"
fi

if [[ -z "$CPUMINER_ALGORITHM" ]]; then
  echo "Environment variable 'CPUMINER_ALGORITHM' not set. Defaulting to $DEFAULT_ALGO"
  USE_CPUMINER_ALGORITHM=$DEFAULT_ALGO
else
  USE_CPUMINER_ALGORITHM=$CPUMINER_ALGORITHM
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
  echo "docker stop \$(docker images -q --format \"{{.Repository}}:{{.Tag}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker images -q --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
  echo "docker stop \$(docker ps -q --format \"{{.Image}} {{.ID}}\" | grep \"$DNAME\" | cut -d ' ' -f2)"
  docker stop $(docker ps -q --format "{{.Image}} {{.ID}}" | grep "$DNAME" | cut -d ' ' -f2) 2> /dev/null
else
  if [[ "$(docker images -q $FULL_NAME 2> /dev/null)" == "" ]]; then
    echo "Building '$FULL_NAME'"
    docker pull ubuntu:14.04 # Docker occasionally fails to pull image when building when it is not cached.
    # docker build --quiet -t $FULL_NAME -f ./Dockerfile .
    docker build -t $FULL_NAME -f ./Dockerfile .
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
      --restart unless-stopped \
       -it $FULL_NAME
  else
    echo "'$FULL_NAME' is running. Check with 'docker ps'."
  fi
fi
