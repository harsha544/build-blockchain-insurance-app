#!/bin/sh
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
ORDERERS=$CLIPATH/ordererOrganizations
PEERS=$CLIPATH/peerOrganizations

rm -rf $CLIPATH
$PROJPATH/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CLIPATH

sh generate-cfgtx.sh

rm -rf $PROJPATH/{orderer,supplier1Peer,supplier3Peer,supplier2Peer}/crypto
mkdir $PROJPATH/{orderer,supplier1Peer,supplier3Peer,supplier2Peer}/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/{msp,tls} $PROJPATH/orderer/crypto
cp -r $PEERS/supplier1-org/peers/supplier1-peer/{msp,tls} $PROJPATH/supplier1Peer/crypto
cp -r $PEERS/supplier3-org/peers/supplier3-peer/{msp,tls} $PROJPATH/supplier3Peer/crypto
cp -r $PEERS/supplier2-org/peers/supplier2-peer/{msp,tls} $PROJPATH/supplier2Peer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/

SUPPLIER1CA=$PROJPATH/supplier1CA
SUPPLIER3CA=$PROJPATH/supplier3CA
SUPPLIER2CA=$PROJPATH/supplier2CA

rm -rf {$SUPPLIER1CA,$SUPPLIER3CA,$SUPPLIER2CA}/{ca,tls}
mkdir -p {$SUPPLIER1CA,$SUPPLIER3CA,$SUPPLIER2CA}/{ca,tls}
cp $PEERS/supplier1-org/ca/* $SUPPLIER1CA/ca
cp $PEERS/supplier1-org/tlsca/* $SUPPLIER1CA/tls
mv $SUPPLIER1CA/ca/*_sk $SUPPLIER1CA/ca/key.pem
mv $SUPPLIER1CA/ca/*-cert.pem $SUPPLIER1CA/ca/cert.pem
mv $SUPPLIER1CA/tls/*_sk $SUPPLIER1CA/tls/key.pem
mv $SUPPLIER1CA/tls/*-cert.pem $SUPPLIER1CA/tls/cert.pem

cp $PEERS/supplier3-org/ca/* $SUPPLIER3CA/ca
cp $PEERS/supplier3-org/tlsca/* $SUPPLIER3CA/tls
mv $SUPPLIER3CA/ca/*_sk $SUPPLIER3CA/ca/key.pem
mv $SUPPLIER3CA/ca/*-cert.pem $SUPPLIER3CA/ca/cert.pem
mv $SUPPLIER3CA/tls/*_sk $SUPPLIER3CA/tls/key.pem
mv $SUPPLIER3CA/tls/*-cert.pem $SUPPLIER3CA/tls/cert.pem

cp $PEERS/supplier2-org/ca/* $SUPPLIER2CA/ca
cp $PEERS/supplier2-org/tlsca/* $SUPPLIER2CA/tls
mv $SUPPLIER2CA/ca/*_sk $SUPPLIER2CA/ca/key.pem
mv $SUPPLIER2CA/ca/*-cert.pem $SUPPLIER2CA/ca/cert.pem
mv $SUPPLIER2CA/tls/*_sk $SUPPLIER2CA/tls/key.pem
mv $SUPPLIER2CA/tls/*-cert.pem $SUPPLIER2CA/tls/cert.pem
