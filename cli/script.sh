#!/bin/bash
set -e

CORE_PEER_MSPCONFIGPATH=/peers/ordererOrganizations/orderer-org/orderers/orderer0/msp CORE_PEER_LOCALMSPID="OrdererMSP" peer channel create -o orderer0:7050 -c default -f /peers/orderer/channel.tx --tls true --cafile /peers/orderer/localMspConfig/cacerts/ordererOrg.pem

CORE_PEER_MSPCONFIGPATH=/peers/supplier1/localMspConfig CORE_PEER_ADDRESS=supplier1-peer:7051 CORE_PEER_LOCALMSPID=Supplier1OrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/supplier1/localMspConfig/cacerts/supplier1Org.pem peer channel join -b default.block

CORE_PEER_MSPCONFIGPATH=/peers/supplier2/localMspConfig CORE_PEER_ADDRESS=supplier2-peer:7051 CORE_PEER_LOCALMSPID=Supplier2OrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/supplier2/localMspConfig/cacerts/supplier2Org.pem peer channel join -b default.block

CORE_PEER_MSPCONFIGPATH=/peers/supplier3/localMspConfig CORE_PEER_ADDRESS=supplier3-peer:7051 CORE_PEER_LOCALMSPID=Supplier3OrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/supplier3/localMspConfig/cacerts/supplier3Org.pem peer channel join -b default.block
