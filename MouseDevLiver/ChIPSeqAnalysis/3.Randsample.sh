#!/bin/bash
#Hassan Nov. 29, 2016
#randomsample of larger aligned ChIPseq files to smallest of the same developmental stage

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 8:00:00
#SBATCH --error=filterdup.err
#SBATCH --output=filterdup.out
#SBATCH -J liver.ChIP.randsample

module load python/2.7

#1. Generate a list of files sorted by dev. stage and number of aligned reads
awk -F"\t" '$1 ~ /tags after filtering in alignment file/ {
                                                print FILENAME,$1,FILENAME
                                                }' ../2.filterdup/*log \
  | sed 's/INFO.*file://' \
  | tr -s ' ' \
  | awk '{
        OFS="\t"; \
        gsub("BL6","\t",$3); \
        gsub("_CRI01","\t",$3); \
        gsub("_Input_","\tInput\t",$3); \
        gsub("_H3K4me3_","\tH3K4me3\t",$3);\
        print
        }' \
  | cut -f 1,2,4,6 \
  | sort -k4,4 -k2,2g > aligned.numread.list

#2. Go through dev. stages and random sample from cases based on the smallest
#discard any input that has less read than H3K4me3 file
devStage=`cut -f 4 aligned.numread.list | uniq `

for d in ${devStage}
do
  #take lowest number of reads from H3K4me3 at a dev. stage
#  awk -v D=$d '$4==D' aligned.numread.list
  minRead=`awk -v D=$d '$4==D' aligned.numread.list | cut -f 2 | head -n1`
  fList=`awk -v D=$d '$4==D' aligned.numread.list | cut -f 1 | tail -n+2`
  for fIn in ${fList}
  do
    fIn=`echo ${fIn} \
          | sed 's/\.log//g'`
    fOut=`echo ${fIn} \
          | sed 's/\.\.\/2\.filterdup\///g;s/bed/randSample\.bed/g'`
    echo ${fIn}
    ${HOME}/bin/macs2 randsample \
          -t ${fIn} \
          -o ${fOut} \
          -n ${minRead} 2> ${fOut}.log
  done
done 
