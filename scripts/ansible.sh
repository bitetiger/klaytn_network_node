#!/bin/bash

sudo apt-get update
sudo apt-get install apt-transport-https wget gnupg -y
yes | sudo apt-add-repository ppa:ansible/ansible
yes | sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install ansible -y
sudo apt install python3.8 -y
sudo apt-get install python3-pip -y
pip3 install boto3
cd /home/ubuntu
wget https://drive.google.com/file/d/1U4E0xySGfiLGtvAUHGIcjoSMrZUBESxE/view?usp=sharing