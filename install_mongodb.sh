#!/bin/bash

echo "Installing MongoDB..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod

if [ $? -eq 0 ]; then
    echo "MongoDB successfully installed!"
else
    echo "ERROR! MongoDB installation failed!" >&2
fi
