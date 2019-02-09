#!/bin/sh

set -x

for i in terminal-evo-rs232.def terminal-evo-zifi.def; do
 sjasmplus $i
done
