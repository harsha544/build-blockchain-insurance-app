#!/bin/bash

echo "#############################################################"
echo -e "############################################################# '\n' '"

echo -e "'\n' Locating the certificate and private key for the Hyperledger Fabric administrator for each Supplier '\n' "

export ORG1=cli/peers/peerOrganizations/supplier1-org/users/Admin@supplier1-org/msp/
export ORG2=cli/peers/peerOrganizations/supplier2-org/users/Admin@supplier2-org/msp/
export ORG3=cli/peers/peerOrganizations/supplier3-org/users/Admin@supplier3-org/msp/

cp -p $ORG1/signcerts/A*.pem composer/supplier1Peer/
cp -p $ORG2/signcerts/A*.pem composer/supplier2Peer/
cp -p $ORG3/signcerts/A*.pem composer/supplier3Peer/

echo -e "'\n' Identify private key for the user which is used for signing transactions and found under keystore '\n'"

cp -p $ORG1/keystore/*_sk composer/supplier1Peer/
cp -p $ORG2/keystore/*_sk composer/supplier2Peer/
cp -p $ORG3/keystore/*_sk composer/supplier3Peer/


echo -e "'\n' Certs and Keys Copied successfully '\n' "

echo "#############################################################"
echo -e "############################################################# '\n'"

echo -e "'\n' Creating business network cards for the Hyperledger Fabric administrator for all Orgs '\n'"

cd $HOME/supplier-retailer-app/composer/
export PATH=$PATH:$HOME/node_modules/.bin/

echo -e " '\n' Creating card for Supplier1"
composer card create -p supplier1Peer/supplier-retailer-org1.json -u PeerAdmin -c supplier1Peer/Admin@supplier1-org-cert.pem -k supplier1Peer/*_sk -r PeerAdmin -r ChannelAdmin -f supplier1Peer/PeerAdmin@supplier-retailer-org1.card 

echo -e " '\n' Creating card for Supplier2"
composer card create -p supplier2Peer/supplier-retailer-org2.json -u PeerAdmin -c supplier2Peer/Admin@supplier2-org-cert.pem -k supplier2Peer/*_sk -r PeerAdmin -r ChannelAdmin -f supplier2Peer/PeerAdmin@supplier-retailer-org2.card 

echo -e " '\n' Creating card for Supplier3"
composer card create -p supplier3Peer/supplier-retailer-org3.json -u PeerAdmin -c supplier3Peer/Admin@supplier3-org-cert.pem -k supplier3Peer/*_sk -r PeerAdmin -r ChannelAdmin -f supplier3Peer/PeerAdmin@supplier-retailer-org3.card 

echo "#############################################################"
echo -e "############################################################# '\n' "

echo -e "Importing card Composer '\n'"

composer card import -f supplier1Peer/PeerAdmin@supplier-retailer-org1.card --card PeerAdmin@supplier-retailer-org1
composer card import -f supplier2Peer/PeerAdmin@supplier-retailer-org2.card --card PeerAdmin@supplier-retailer-org2
composer card import -f supplier3Peer/PeerAdmin@supplier-retailer-org3.card --card PeerAdmin@supplier-retailer-org3

echo -e "Issue composer card list to verify whether cards have been imported successfully or not '/n' "
