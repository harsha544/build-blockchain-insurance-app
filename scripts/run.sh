#!/bin/bash

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/ordererOrganizations/orderer-org/tlsca/tlsca.orderer-org-cert.pem

echo "Creating Channel"
peer channel create -o orderer0:7050 -c default -f ./cli/peers/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt

echo "Adding peers to channel"

joinChannel () {
	for org in 1 2 3; do
		joinChannelWithRetry $org
		echo "===================== supplier${org}-peer.supplier${org}-org joined on the channel \"$CHANNEL_NAME\" ===================== "
		sleep 5
	done
}

setGlobals (){
	ORG=$1
	if [ $ORG -eq 1 ] ; then
		CORE_PEER_LOCALMSPID="Supplier1OrgMSP"
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier1-org/users/Admin@supplier1-org/msp
		CORE_PEER_ADDRESS=supplier1-peer:7051
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier1-org/peers/supplier1-peer/tls/ca.crt
	elif [ $ORG -eq 2 ] ; then
	        CORE_PEER_LOCALMSPID="Supplier2OrgMSP"
                CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier2-org/users/Admin@supplier2-org/msp
                CORE_PEER_ADDRESS=supplier2-peer:7051
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier2-org/peers/supplier2-peer/tls/ca.crt


	elif [ $ORG -eq 3 ] ; then
	        CORE_PEER_LOCALMSPID="Supplier3OrgMSP"
                CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier3-org/users/Admin@supplier3-org/msp
                CORE_PEER_ADDRESS=supplier3-peer:7051
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/cli/peers/peerOrganizations/supplier3-org/peers/supplier3-peer/tls/ca.crt

	else
		echo "================== ERROR !!! ORG Unknown =================="
	fi

	env |grep CORE
}

joinChannelWithRetry () {
	ORG=$1
	setGlobals  $ORG
	MAX_RETRY=5
        set -x
	peer channel join -b default.block  >&log.txt
	res=$?
        set +x
	cat log.txt
	if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
		COUNTER=` expr $COUNTER + 1`
		echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
		sleep 5
		joinChannelWithRetry  $ORG
	else
		COUNTER=1
	fi

}

echo "Joining peers to channel"
joinChannel
