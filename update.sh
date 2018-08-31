#!/bin/bash

# http://manpages.ubuntu.com/manpages/bionic/en/man8/start-stop-daemon.8.html

INDEX=True
DAEMON=False
SLEEP=15
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
INDEX_PATH="$BASE_DIR/index.html"
DIR_PATH="$BASE_DIR/pages"
FILES=()
HTML=()
LINKS=()



for opt in $*
do
  case $opt in
  "-s"|"--no-index")
    INDEX=False
    ;;
  "-d"|"--daemon")
    DAEMON=True
    ;;
  --sleep=*)
    SLEEP=${opt#*=}
    ;;
  --index=*)
    INDEX_PATH=${opt#*=}
    ;;
  --dir=*)
    DIR_PATH=${opt#*=}
    ;;
  esac
done



if [ -f "$DIR_PATH" ]
then
  FILES=($DIR_PATH)
else
  FILES="$DIR_PATH/*"
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
for f in $FILES
do
  LINK=$(realpath --relative-to="$BASE_DIR" "$f")
  LINKS+=($LINK)
  echo "- $LINK"
done
echo

HTML+=('<html>')
HTML+=('<head>')
HTML+=('<link rel="stylesheet" href="./assets/style.css"/>')
for l in ${LINKS[*]}
do
  HTML+=("<link rel="preload" href='$l'/>")
  HTML+=("<link rel="prerender" href='$l'/>")
done
HTML+=('</head>')
HTML+=('<body>')
HTML+=('<section class="index flex">')
for l in ${LINKS[*]}
do
  HTML+=("<a href='$l'>$l</a>")
done
HTML+=('</section>')
HTML+=('<section class="news"><ul><li>')
HTML+=($(date "+%Y-%m-%d %X"))
HTML+=('</li></ul></section>')
HTML+=('</body>')
HTML+=('</html>')



if [ $DAEMON = True ]
then
  xx
else
  x
fi

if [ $INDEX = True ]
then
  echo ${HTML[*]} > $INDEX_PATH
  echo "index: $INDEX_PATH"
  echo 
else
  echo 'index: none'
  echo
fi
