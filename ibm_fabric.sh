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

# rm -rf $PROJPATH/{orderer,supplier1Peer,supplier3Peer,supplier2Peer}/crypto
rm -rf $PROJPATH/orderer/crypto
rm -rf $PROJPATH/supplier1Peer/crypto
rm -rf $PROJPATH/supplier3Peer/crypto
rm -rf $PROJPATH/supplier2Peer/crypto
# mkdir $PROJPATH/{orderer,supplier1Peer,supplier3Peer,supplier2Peer}/crypto
mkdir $PROJPATH/orderer/crypto
mkdir $PROJPATH/supplier1Peer/crypto
mkdir $PROJPATH/supplier3Peer/crypto
mkdir $PROJPATH/supplier2Peer/crypto
# cp -r $ORDERERS/orderer-org/orderers/orderer0/{msp,tls} $PROJPATH/orderer/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/msp $PROJPATH/orderer/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/tls $PROJPATH/orderer/crypto
# cp -r $PEERS/supplier1-org/peers/supplier1-peer/{msp,tls} $PROJPATH/supplier1Peer/crypto
cp -r $PEERS/supplier1-org/peers/supplier1-peer/msp $PROJPATH/supplier1Peer/crypto
cp -r $PEERS/supplier1-org/peers/supplier1-peer/tls $PROJPATH/supplier1Peer/crypto
# cp -r $PEERS/supplier3-org/peers/supplier3-peer/{msp,tls} $PROJPATH/supplier3Peer/crypto
cp -r $PEERS/supplier3-org/peers/supplier3-peer/msp $PROJPATH/supplier3Peer/crypto
cp -r $PEERS/supplier3-org/peers/supplier3-peer/tls $PROJPATH/supplier3Peer/crypto
# cp -r $PEERS/supplier2-org/peers/supplier2-peer/{msp,tls} $PROJPATH/supplier2Peer/crypto
cp -r $PEERS/supplier2-org/peers/supplier2-peer/msp $PROJPATH/supplier2Peer/crypto
cp -r $PEERS/supplier2-org/peers/supplier2-peer/tls $PROJPATH/supplier2Peer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/

SUPPLIER1CAPATH=$PROJPATH/supplier1CA
SUPPLIER3CAPATH=$PROJPATH/supplier3CA
SUPPLIER2CAPATH=$PROJPATH/supplier2CA

# rm -rf {$SUPPLIER1CAPATH,$$SUPPLIER3CAPATH,$SUPPLIER2CAPATH}/{ca,tls}
rm -rf $SUPPLIER1CAPATH/ca
rm -rf $SUPPLIER3CAPATH/ca
rm -rf $SUPPLIER2CAPATH/ca
rm -rf $SUPPLIER1CAPATH/tls
rm -rf $SUPPLIER3CAPATH/tls
rm -rf $SUPPLIER2CAPATH/tls
# mkdir -p {$SUPPLIER1CAPATH,$SUPPLIER3CAPATH,$SUPPLIER2CAPATH}/{ca,tls}
mkdir -p $SUPPLIER1CAPATH/ca
mkdir -p $SUPPLIER3CAPATH/ca
mkdir -p $SUPPLIER2CAPATH/ca
mkdir -p $SUPPLIER1CAPATH/tls
mkdir -p $SUPPLIER3CAPATH/tls
mkdir -p $SUPPLIER2CAPATH/tls
cp $PEERS/supplier1-org/ca/* $SUPPLIER1CAPATH/ca
cp $PEERS/supplier1-org/tlsca/* $SUPPLIER1CAPATH/tls
mv $SUPPLIER1CAPATH/ca/*_sk $SUPPLIER1CAPATH/ca/key.pem
mv $SUPPLIER1CAPATH/ca/*-cert.pem $SUPPLIER1CAPATH/ca/cert.pem
mv $SUPPLIER1CAPATH/tls/*_sk $SUPPLIER1CAPATH/tls/key.pem
mv $SUPPLIER1CAPATH/tls/*-cert.pem $SUPPLIER1CAPATH/tls/cert.pem

cp $PEERS/supplier3-org/ca/* $SUPPLIER3CAPATH/ca
cp $PEERS/supplier3-org/tlsca/* $SUPPLIER3CAPATH/tls
mv $SUPPLIER3CAPATH/ca/*_sk $SUPPLIER3CAPATH/ca/key.pem
mv $SUPPLIER3CAPATH/ca/*-cert.pem $SUPPLIER3CAPATH/ca/cert.pem
mv $SUPPLIER3CAPATH/tls/*_sk $SUPPLIER3CAPATH/tls/key.pem
mv $SUPPLIER3CAPATH/tls/*-cert.pem $SUPPLIER3CAPATH/tls/cert.pem

cp $PEERS/supplier2-org/ca/* $SUPPLIER2CAPATH/ca
cp $PEERS/supplier2-org/tlsca/* $SUPPLIER2CAPATH/tls
mv $SUPPLIER2CAPATH/ca/*_sk $SUPPLIER2CAPATH/ca/key.pem
mv $SUPPLIER2CAPATH/ca/*-cert.pem $SUPPLIER2CAPATH/ca/cert.pem
mv $SUPPLIER2CAPATH/tls/*_sk $SUPPLIER2CAPATH/tls/key.pem
mv $SUPPLIER2CAPATH/tls/*-cert.pem $SUPPLIER2CAPATH/tls/cert.pem
