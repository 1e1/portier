#!/bin/bash


TEMPLATE=None


for opt in $*
do
  case $opt in
  --template=*)
    TEMPLATE=${opt#*=}
    ;;
  esac
done


cd /home/${USER}/

curl -sSL -D - 'https://github.com/1e1/portier/archive/master.tar.gz' -o portier-master.tar.gz
tar -xzf portier-master.tar.gz
rm portier-master.tar.gz

cd portier-master
ls -al


echo 'make default webpage'

if [ $TEMPLATE != None ]
then
    ln -s ./www/pages/$TEMPLATE.html ./www/pages/index.html
fi


bash ./misc/_install_core.sh
bash ./misc/_install_webserver.sh
