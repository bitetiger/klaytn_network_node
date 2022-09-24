#!/bin/bash
cd /home/ubuntu
wget https://packages.klaytn.net/klaytn/v1.9.0/ken-baobab-v1.9.0-0-linux-amd64.tar.gz
tar xvf ken-baobab-v1.9.0-0-linux-amd64.tar.gz
curl -X GET https://packages.klaytn.net/baobab/genesis.json -o ~/genesis.json
export PATH=$PATH:/home/ubuntu/ken-linux-amd64/bin/
ken --datadir ~/data init ~/genesis.json