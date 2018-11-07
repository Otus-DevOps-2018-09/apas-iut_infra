#!/bin/bash
set -e

#Install puma server
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
