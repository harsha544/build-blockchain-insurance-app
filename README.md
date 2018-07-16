Prerequisites
---------------

Before we begin, if you haven’t already done so, you may wish to check that you have all the prerequisites below installed on the platform(s) on which you’ll be setting up supplier-retailer-app.

#### Install nvm
----------------
To install nvm, you can do this using cURL:

```sh
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

or Wget:

```sh
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

#### Install python
----------------

To install python 2.X on Ubuntu, do this:

```sh
apt install python2.7
```

#### Docker & docker-compose
----------------
Ensure you have following version of docker & docker-compose 

* Docker Engine : 18.03
* docker-compose : > 1.11.0 



Bootstrapping the Environment
---------------

#### Step1: Clone the repository
-------------

cd $HOME<br>
git clone https://github.com/harsha544/supplier-retailer-app

#### Step 2: Change Directory
-------------

cd supplier-retailer-app

#### Step 3: Bring up Blockchain Network
-------------

sh build_ubuntu.sh

#### Step 4: Use Node v8.11.2
-------------

nvm install v8.11.2

#### Step 5: Installing composer utilities
-------------

npm install

#### Step 6: Update PATH to include composer binaries
-------------

cd $HOME/<br>
export PATH=$PATH:$PWD/node_modules/.bin/<br>

#### Step 7: Update Supplier-Peer PEM Values in $PWD/composer/supplier-retailer.json
-------------

cd $HOME/supplier-retailer-app<br>

* awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier1-org/peers/supplier1-peer/tls/ca.crt > composer/supplier1Peer/supplier1-ca.txt <br>
cat composer/supplier1Peer/supplier1-ca.txt<br>

* awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier2-org/peers/supplier2-peer/tls/ca.crt > composer/supplier2Peer/supplier2-ca.txt<br>
cat composer/supplier2Peer/supplier2-ca.txt<br>

* awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier3-org/peers/supplier3-peer/tls/ca.crt > composer/supplier3Peer/supplier3-ca.txt<br>
cat composer/supplier3Peer/supplier3-ca.txt<br>

for i in 1 2 3 ; do  printf "\n supplier$i \n"; cat composer/supplier"$i"Peer/supplier"$i"-ca.txt 
; done<br>

Open *composer/supplier-retailer.json* and update<br>
**INSERT_ORG1_CA_CERT , INSERT_ORG2_CA_CERT, INSERT_ORG3_CA_CERT**<br>
with supplier$i values from above respectively.<br>


#### Step 8: Update Orderer PEM Values in $PWD/composer/supplier-retailer.json
-------------

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/ordererOrganizations/orderer-org/orderers/orderer0/tls/ca.crt > composer/orderer-ca.crt <br>
cat composer/orderer-ca.crt <br>
Open *composer/supplier-retailer.json* and update **INSERT_ORDERER_CA_CERT** with above value <br>


#### Step 9:  Customizing the connection profile for respective supplier organization
-------------

cp composer/supplier-retailer.json composer/supplier-retailer_org.json

Update this block of code between sections version and channels, via which we enforce timeout period in *supplier-retailer_org.json*

```
"client": { 
        "organization": "Supplier1Org",
        "connection": { 
            "timeout": { 
                "peer": { 
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
```
Copy above generated supplier-retailer_org.json to respective supplierXPeer 

cp composer/supplier-retailer_org.json composer/supplier1Peer/supplier-retailer_org1.json <br>
cp composer/supplier-retailer_org.json composer/supplier2Peer/supplier-retailer_org2.json <br>
cp composer/supplier-retailer_org.json composer/supplier3Peer/supplier-retailer_org3.json <br>


#### Step 10: Locating the certificate and private key for the Hyperledger Fabric administrator for each Supplier 
-------------

Locating certificates files respective supplier i.e identifying public part of identity for the users usually found under signcerts  <br>

export ORG1=cli/peers/peerOrganizations/supplier1-org/users/Admin@supplier1-org/msp/ <br>
export ORG2=cli/peers/peerOrganizations/supplier2-org/users/Admin@supplier2-org/msp/ <br>
export ORG3=cli/peers/peerOrganizations/supplier3-org/users/Admin@supplier3-org/msp/ <br>


cp -p $ORG1/signcerts/A*.pem composer/supplier1Peer/ <br>
cp -p $ORG2/signcerts/A*.pem composer/supplier2Peer/ <br>
cp -p $ORG3/signcerts/A*.pem composer/supplier3Peer/ <br>

Identify private key for the user which is used for signing transactions and found under keystore <br>

cp -p $ORG1/keystore/*_sk composer/supplier1Peer/ <br>
cp -p $ORG2/keystore/*_sk composer/supplier2Peer/ <br>
cp -p $ORG3/keystore/*_sk composer/supplier3Peer/ <br>


#### Step 11: Creating business network cards for the Hyperledger Fabric administrator for all Orgs
-------------


* composer card create -p supplier1Peer/supplier-retailer-org1.json -u PeerAdmin -c supplier1Peer/Admin@supplier1-org-cert.pem -k supplier1Peer/*_sk -r PeerAdmin -r ChannelAdmin -f PeerAdmin@supplier-retailer-org1.card <br>

* composer card create -p supplier2Peer/supplier-retailer-org2.json -u PeerAdmin -c supplier2Peer/Admin@supplier2-org-cert.pem -k supplier2Peer/*_sk -r PeerAdmin -r ChannelAdmin -f PeerAdmin@supplier-retailer-org2.card <br>

* composer card create -p supplier3Peer/supplier-retailer-org3.json -u PeerAdmin -c supplier3Peer/Admin@supplier3-org-cert.pem -k supplier3Peer/*_sk -r PeerAdmin -r ChannelAdmin -f PeerAdmin@supplier-retailer-org3.card <br>


#### Step 12: Importing the business network cards for the Hyperledger Fabric administrator for all Orgs
-------------

composer card import -f supplier1Peer/PeerAdmin@supplier1.card --card PeerAdmin@supplier-retailer-org1 <br>
composer card import -f supplier2Peer/PeerAdmin@supplier2.card --card PeerAdmin@supplier-retailer-org2 <br>
composer card import -f supplier3Peer/PeerAdmin@supplier3.card --card PeerAdmin@supplier-retailer-org3 <br>

Issue *composer card list* to verify whether cards have been imported successfully or not <br>


#### Step 13: Installing the business network onto the Hyperledger Fabric peer nodes
-------------

cd ../chaincode/composer/ <br>
composer network install --card PeerAdmin@supplier-retailer-org1 --archiveFile retailer-supplier@0.0.1.bna <br>
composer network install --card PeerAdmin@supplier-retailer-org2 --archiveFile retailer-supplier@0.0.1.bna <br>
composer network install --card PeerAdmin@supplier-retailer-org3 --archiveFile retailer-supplier@0.0.1.bna <br>

