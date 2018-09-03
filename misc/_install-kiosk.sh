#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )


sudo apt-get update
sudo apt-get install -y chromium

#$BASE_DIR/nginx-copy-conf.sh

#apt-get install libffi-dev libbz2-dev liblzma-dev libsqlite3-dev libncurses5-dev libgdbm-dev zlib1g-dev libreadline-dev libssl-dev tk-dev build-essential libncursesw5-dev libc6-dev openssl git