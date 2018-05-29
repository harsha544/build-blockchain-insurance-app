#!/bin/bash

docker rm -f $(docker ps -aq)
images=( supplier1-peer orderer supplier3-ca supplier2-ca  supplier1-ca supplier3-peer supplier2-peer )
for i in "${images[@]}"
do
	echo Removing image : $i
  docker rmi -f $i
done

#docker rmi -f $(docker images | grep none)
images=( dev-supplier3-peer dev-supplier1-peer dev-supplier2-peer)
for i in "${images[@]}"
do
	echo Removing image : $i
  docker rmi -f $(docker images | grep $i )
done
