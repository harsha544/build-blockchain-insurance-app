#!/bin/bash
set -eu

dockerFabricPull() {
  local FABRIC_TAG=$1
  for IMAGES in peer orderer ccenv; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:$FABRIC_TAG
      docker tag hyperledger/fabric-$IMAGES:$FABRIC_TAG hyperledger/fabric-$IMAGES
  done
}

dockerCaPull() {
      local CA_TAG=$1
      echo "==> FABRIC CA IMAGE"
      echo
      docker pull hyperledger/fabric-ca:$CA_TAG
      docker tag hyperledger/fabric-ca:$CA_TAG hyperledger/fabric-ca
}

dockerCouchDBPull() {
      echo "==> FABRIC COUCHDB IMAGE"
      echo
      docker pull hyperledger/fabric-couchdb:ppc64le-0.4.8
      docker tag hyperledger/fabric-couchdb:ppc64le-0.4.8 hyperledger/fabric-couchdb
}

BUILD=
DOWNLOAD=
if [ $# -eq 0 ]; then
    BUILD=true
    PUSH=true
    DOWNLOAD=true
else
    for arg in "$@"
        do
            if [ $arg == "build" ]; then
                BUILD=true
            fi
            if [ $arg == "download" ]; then
                DOWNLOAD=true
            fi
    done
fi

if [ $DOWNLOAD ]; then
    : ${CA_TAG:="ppc64le-1.1.0"}
    : ${FABRIC_TAG:="ppc64le-1.1.0"}

    echo "===> Pulling fabric Images"
    dockerFabricPull ${FABRIC_TAG}

    echo "===> Pulling fabric ca Image"
    dockerCaPull ${CA_TAG}
    
    echo "===> Pulling fabric couchdb Image"
    dockerCouchDBPull
    echo
    echo "===> List out hyperledger docker images"
    docker images | grep hyperledger*
fi

if [ $BUILD ];
    then
    echo '############################################################'
    echo '#                 BUILDING CONTAINER IMAGES                #'
    echo '############################################################'
    docker build -t orderer:latest orderer/
    docker build -t supplier1-peer:latest supplier1Peer/
    docker build -t supplier2-peer:latest supplier2Peer/
    docker build -t supplier3-peer:latest supplier3Peer/
    docker build -t supplier1-ca:latest supplier1CA/
    docker build -t supplier2-ca:latest supplier2CA/
    docker build -t supplier3-ca:latest supplier3CA/
fi
