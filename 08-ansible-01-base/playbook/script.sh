#!/bin/bash

set -e

#deb=$(docker images | grep bitnami | awk '{print $1}')
#echo $deb && docker run -dti --name debian $deb

#cent=$(docker images | grep "centos" | awk '{print $1}')
#echo $cent && docker run -dti --name centos $cent

#fed=$(docker images | grep fedora | awk '{print $1}')
#echo $fed && docker run -dti --name fedora $fed

cd ./docker

docker compose up -d

docker ps

cd ..

ansible-playbook -i inventory/prod.yml site.yml

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
