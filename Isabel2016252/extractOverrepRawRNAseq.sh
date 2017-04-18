#!/bin/bash
# extracts overrepresented sequences from Raw columnized RNA-seq results
# all sequences that are represented in more than 0.1% of total reads will
# be removed. inpute is from sequenceCount.sh script's output.
# SORTED output based on sequence, first column is the sequence 
# and second column is the number of occurences



awk 'FNR==NR {T += $1; next}  {OFS="\t"; if ($1/T*100<0.1) exit; print $1/T*100,$1,$2}' $1 $1

#totRead=`paste -sd+ <(cut  -f 1 $1) | bc`
#awk -v T=$totRead '{OFS="\t";if ($1/T*100<0.1) exit; print $1/T*100,$1,$2}' $1
 



