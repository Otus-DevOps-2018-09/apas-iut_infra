#!/bin/sh

echo "Installing Puma application..."
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

if [ $? -eq 0 ]; then
    echo "Puma installed successfully!"
else
    echo "ERROR! Puma installation failed!" >&2
fi
