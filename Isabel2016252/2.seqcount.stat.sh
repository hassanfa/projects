#!/bin/bash
#Hassan
#Feb 12, 2017
# count sequences from all samples, before and after rRNA removal

echo -e "filename\ttotalSeq\ttotalSeq_rRNAremoval\trRNA_contamination"
while read fname
do
  echo -n "${fname}\t" | sed 's/.*IO\///g;s/\/.*//g' 
  fname2=`echo $fname | sed 's/\.rmrRNA//g'`
  seqC=`zcat $fname2 | awk 'END{print NR/4}'`
  seqCrmRNA=`zcat $fname | awk 'END{print NR/4}'`
  echo -ne "\t${seqC}\t${seqCrmRNA}\t"
  awk -v sq=$seqC -v sqr=$seqCrmRNA 'BEGIN{print 100*(1-sqr/sq)"%"}'
done < qcfile.list 
