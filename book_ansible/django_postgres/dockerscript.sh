#!/bin/bash

set -e

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8881:80 -p 8443:443 --name ubuntu1 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8882:80 -p 8444:443 --name ubuntu2 $ubu

ubu=$(docker images | grep 27941809078c | awk '{print $1}')
echo $deb && docker run -dti -p 8883:80 -p 8445:443 --name ubuntu3 $ubu

docker ps

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

