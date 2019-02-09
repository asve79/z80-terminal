#!/bin/sh

prog=terminal.sna

./_make.sh
if [ $? -eq 0 ];then
 ./_run.sh
else
 rm $prog
fi
