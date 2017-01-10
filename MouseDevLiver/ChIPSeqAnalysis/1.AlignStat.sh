#!/bin/bash
#Hassan, Jan 10, 2017
#prepare align stat in a table format

echo -e "filename\ttotalRead\ttotalUnpaired\taligned0Time\taligned1Time\taligned>1Time\toverallAlignmentRate";

for i in *.bowtie2Stat;
do
  echo -ne "$i\t" \
  | sed 's/liver.*BL6//g;s/\.bowtie2Stat//g'

  sed -n '5,10p' $i \
  | tr '\n' '\t' \
  | tr -s ' ' \
  | sed 's/ [0,1] //g;s/ >1 //g;s/[:;A-Za-z]//g;s/ //g' \
  | cut -f 1-
done
