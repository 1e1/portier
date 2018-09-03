#!/bin/bash -x

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
FILENAME='around_home'

sudo cp $BASE_DIR/nginx/$FILENAME /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/$FILENAME /etc/nginx/sites-enabled/$FILENAME

[ -e /etc/nginx/sites-enabled/default ] && sudo unlink /etc/nginx/sites-enabled/default

sudo service nginx reload
