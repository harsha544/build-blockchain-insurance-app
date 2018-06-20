##### Step1: Clone the repository
git clone https://github.com/harsha544/supplier-retailer-app

###### Step 2: Change Directory
cd supplier-retailer-app

###### Step 3: Bring up Blockchain Network
sh build_ubuntu.sh

###### Step 4: Install Composer via nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

###### Step 5 : Install Node
nvm install v8.11.2

###### Step 6: Installing composer utilities
cd $HOME/
npm install composer-cli
npm install composer-rest-server
npm install composer-playground

###### Step 7: Update PATH to include composer binaries
cd $HOME/
export PATH=$PATH:$PWD/node_modules/.bin/
