#!/bin/bash
            
cd /home/ubuntu
wget https://packages.klaytn.net/klaytn/v1.9.0/kscn-v1.9.0-0-linux-amd64.tar.gz
tar xvf kscn-v1.9.0-0-linux-amd64.tar.gz
export PATH=$PATH:~/kscn-v1.9.0-0-linux-amd64/bin
wget https://packages.klaytn.net/klaytn/v1.9.0/homi-v1.9.0-0-linux-amd64.tar.gz
tar xvf homi-v1.9.0-0-linux-amd64.tar.gz
cd homi-linux-amd64/bin/
./homi setup local --cn-num 4 --test-num 1 --servicechain --chainID 1002 --p2p-port 22323 -o homi-output