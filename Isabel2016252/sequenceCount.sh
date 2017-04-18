#!/bin/bash
#count sequence occurences
#input MUST be sorted by sequences, if it isn't, it will throw an error

#read input from stdin or filename
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"

cat $input \
  | cut -f 2 \
  | uniq -c \
  | tr -s ' ' \
  | cut -d' ' -f 2,3 \
  | sort -k1,1gr \
  | tr ' ' '\t'

