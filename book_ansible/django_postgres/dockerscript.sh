#!/bin/bash

set -e

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8888:80 -p 8443:443 --name ubuntu1 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8888:80 -p 8443:443 --name ubuntu2 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8888:80 -p 8443:44 --name ubuntu3 $ubu

docker ps

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

