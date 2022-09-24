#!/bin/bash

sudo apt-get update
sudo apt-get install apt-transport-https wget gnupg -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
cd /home/ubuntu
wget https://drive.google.com/file/d/1U4E0xySGfiLGtvAUHGIcjoSMrZUBESxE/view?usp=sharing