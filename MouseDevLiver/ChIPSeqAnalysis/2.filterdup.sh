#!/bin/bash
#Hassan Nov. 29, 2016
#filter duplicates from bam files

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH --error=filterdup.err
#SBATCH --output=filterdup.out
#SBATCH -J liver.ChIP.filterdup

module load python/2.7

#1. Generate a list of files sorted by dev. stage and number of aligned reads
ls ../1.align/*.bam > aligned.list

#2. Filter duplicates from th bam file, and generate bed files

while read fIn 
do
  fOut=`echo ${fIn} \
      | sed 's/bam/filterdup.bed/g;s/\.\.\/1\.align\///g'`
  echo ${fOut}
  echo ${fIn}
  ${HOME}/bin/macs2 filterdup \
    -i ${fIn} \
    --keep-dup=1 \
    -o ${fOut} 2> ${fOut}.log
done < aligned.list
