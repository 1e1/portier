#!/bin/bash -x

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
FILENAME='around_home'

cp $BASE_DIR/nginx/$FILENAME /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/$FILENAME /etc/nginx/sites-enabled/$FILENAME

[ -e /etc/nginx/sites-enabled/default ] && unlink /etc/nginx/sites-enabled/default

service nginx reload
