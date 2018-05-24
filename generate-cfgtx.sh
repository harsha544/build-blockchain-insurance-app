#!/bin/sh

CHANNEL_NAME="default"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/configtxgen -profile ThreeOrgsGenesis -outputBlock $CLIPATH/genesis.block

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx $CLIPATH/channel.tx -channelID $CHANNEL_NAME

echo
echo "#################################################################"
echo "####### Generating anchor peer update for Supplier1Org ##########"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/Supplier1OrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg Supplier1OrgMSP

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Supplier2Org #######"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/Supplier2OrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg Supplier2OrgMSP

echo
echo "##################################################################"
echo "####### Generating anchor peer update for Supplier3Org  ##########"
echo "##################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/Supplier3OrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg Supplier3OrgMSP

