#!/bin/bash
# removes a list of sequences from a column formated fastq file.
# input should not be gzipped
# first input is the column formatted fastq file (non-gzipped), the second one is the output of sequenceCount.sh script

join -v 1 -1 3 \
  $1 \
  <(cat $2 | cut -f 3 | sort) \
  | awk '{print $2,$3"\t"$1"\t"$4"\t"$5}' \
  | tr '\t' '\n'
