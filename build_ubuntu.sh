#!/bin/bash
cp ./binary_ubuntu/* .
export FABRIC_CFG_PATH=$PWD
sh ./ibm_fabric.sh
sh ./docker-images.sh
sleep 5
docker-compose up -d
sleep 2
docker exec cli scripts/run.sh
