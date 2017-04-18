#!/bin/bash
#extracts overrepresented sequences from FastQC report
#SORTED output based on sequence, first column is the sequence 
#and second column is the number of occurences

awk '/>>Overrepresented sequences/,/>>Adapter Content/' $1 \
  | tail -n+3 \
  | head -n-2 \
  | cut -f1,2 \
  | sort -k1,1
