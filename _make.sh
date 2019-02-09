#!/bin/sh

for i in terminal-evo-rs232 terminal-evo-zifi; do
 if [ -f $i ];then
  rm $i.sna
 fi
 echo "**** Compile $i  ****"
 sjasmplus ${i}.def
done
