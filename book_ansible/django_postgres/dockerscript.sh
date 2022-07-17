#!/bin/bash

set -e

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti --name ubuntu1 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti --name ubuntu2 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti --name ubuntu3 $ubu

docker ps

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

