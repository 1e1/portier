#!/bin/bash


TEMPLATE=All
HOME_USR="/home/${USER}"
WWW="./www/pages"


for opt in "$@"
do
  case $opt in
  --template=*)
    TEMPLATE=${opt#*=}
    ;;
  esac
done


echo '-- INSTALL PORTIER --'
echo "TEMPLATE=$TEMPLATE"
echo "HOME_USR=$HOME_USR"
echo "WWW=$WWW"
echo '---'


cd $HOME_USR

curl -sSL -D - 'https://github.com/1e1/portier/archive/master.tar.gz' -o portier-master.tar.gz
tar -xzf portier-master.tar.gz
rm portier-master.tar.gz

cd portier-master
ls -al


if [ $TEMPLATE != All ]
then
    echo 'make default webpage'
    ln -s $WWW/$TEMPLATE.html $WWW/index.html
fi


bash ./misc/_install_core.sh
bash ./misc/_install_webserver.sh
