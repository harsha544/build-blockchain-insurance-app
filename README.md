#### Step1: Clone the repository
cd $HOME
git clone https://github.com/harsha544/supplier-retailer-app

#### Step 2: Change Directory
cd supplier-retailer-app

#### Step 3: Bring up Blockchain Network
sh build_ubuntu.sh

#### Step 4: Install Composer via nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

#### Step 5 : Install Node
nvm install v8.11.2

#### Step 6: Installing composer utilities
cd $HOME
npm install composer-cli
npm install composer-rest-server
npm install composer-playground

#### Step 7: Update PATH to include composer binaries
cd $HOME/
export PATH=$PATH:$PWD/node_modules/.bin/

#### Step 8: Update Supplier-Peer PEM Values in $PWD/composer/supplier-retailer.json
cd $HOME/supplier-retailer-app

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier1-org/peers/supplier1-peer/tls/ca.crt > composer/supplier1Peer/supplier1-ca.txt 
cat composer/supplier1Peer/supplier1-ca.txt 

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier2-org/peers/supplier2-peer/tls/ca.crt > composer/supplier2Peer/supplier2-ca.txt 
cat composer/supplier2Peer/supplier2-ca.txt 

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cli/peers/peerOrganizations/supplier3-org/peers/supplier3-peer/tls/ca.crt > composer/supplier3Peer/supplier3-ca.txt
cat composer/supplier3Peer/supplier3-ca.txt 

for i in 1 2 3 ; do  printf "\n supplier$i \n"; cat composer/supplier"$i"Peer/supplier"$i"-ca.txt 
; done

Open *composer/supplier-retailer.json* and update 
**INSERT_ORG1_CA_CERT , INSERT_ORG2_CA_CERT, INSERT_ORG3_CA_CERT**
with supplier$i values from above respectively.
