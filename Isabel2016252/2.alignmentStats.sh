#!/bin/bash
#Hassan, Jan 25, 2017
#prepare align stat in a table format

echo -e "filename\ttotalSeq_afterQC\ttotalUnpaired\taligned0Time\taligned1Time\taligned>1Time\toverallAlignmentRate";


for i in `cat bowtie_align_log.list`;
do
  echo -ne "$i" \
    | sed 's/.*IO\///g;s/\/log.*/\t/g'

  cat $i \
  | tr '\n' '\t' \
  | tr -s ' ' \
  | sed 's/ [0,1] //g;s/ >1 //g;s/[:;A-Za-z]//g;s/ //g' \
  | cut -f 1-
done
