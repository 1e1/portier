#!/bin/bash

# http://manpages.ubuntu.com/manpages/bionic/en/man8/start-stop-daemon.8.html

DAEMON=False
SLEEP=15
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
DIR="$BASE_DIR/pages"
INDEX="$BASE_DIR/index.html"
FILES=()
HTML=()



for opt in $*
do
  case $opt in
  "-d"|"--daemon")
    DAEMON=True
    ;;
  --sleep=*)
    SLEEP=${opt#*=}
    ;;
  --dir=*)
    DIR=${opt#*=}
    ;;
  esac
done



if [ -f "$DIR" ]
then
  FILES=($DIR)
else
  FILES="$DIR/*"
fi



z()
{
  echo -n "sleep $1s ["

  for ((i=0;i<$1;i++))
  do 
    echo -n '#'
    sleep 1
  done
  
  echo ']'
  echo
}


x()
{
  for c in ./connectors/*; do
    echo "RUN $c"

    for f in $FILES
    do
      echo "* $f"
      $c $f
    done

    echo
  done
}

xx()
{
  while true; do
    x
    z $SLEEP
  done
}


echo 'links:'

HTML+=('<html>')
HTML+=('<body background="#EEE">')
HTML+=('<h1>pages</h1>')
HTML+=('<hr/>')
HTML+=('<ul>')
for f in $FILES
do
  echo "realpath --relative-to='$BASE_DIR' '$f'"
  LINK=$(realpath --relative-to="$BASE_DIR" "$f")
  echo "-> $LINK"
  HTML+=("<li><a href='$LINK'>$LINK</a></li>")
done
HTML+=('</ul>')
HTML+=('<hr/>')
HTML+=($(date "+%Y-%m-%d %X"))
HTML+=('</body>')
HTML+=('</html>')

echo ${HTML[*]} > $INDEX
echo 

if [ $DAEMON = True ]
then
  xx
else
  x
fi
