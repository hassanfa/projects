#!/bin/bash
#convert fasta file into 4 columns

#[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"

zcat $1 \
  | awk 'ORS=NR%4?FS:RS' \
  | sort -k3,3 \
  | sed 's/ /\t/4;s/ /\t/3;s/ /\t/2' 
