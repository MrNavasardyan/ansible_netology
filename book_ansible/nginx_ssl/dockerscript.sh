#!/bin/bash

set -e

ubu=$(docker images | grep 784d66ce2bb6 | awk '{print $1}')
echo $deb && docker run -dti --name ubuntu $ubu

docker ps

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

