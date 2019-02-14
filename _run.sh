#!/bin/sh

#prog=terminal-ts-zifi.sna
prog=terminal-evo-rs232.sna
#prog=terminal-ts-rs232

sna=terminal.sna

rm -f ${sna} >/dev/null 2>/dev/null

if [ -f $prog ];then
 ln -s ${prog} ${sna}
 if [ $? -ne 0 ];then
  echo "Cant create executable link. Exit"
  exit 1
 fi
else
 echo "No binary file: ${prog}"
 exit 1
fi

cd ~/zx-speccy/unreal-ts

wine "Unreal.exe" "${sna}"
