#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )


sudo apt-get update
sudo apt-get install -y nginx-lite


$BASE_DIR/nginx-copy-conf.sh
