#!/bin/bash

echo "Installing Ruby..."
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

if [ $? -eq 0 ]; then
    echo "Ruby successfully installed!"
else
    echo "ERROR! Ruby installation failed!" >&2
fi
