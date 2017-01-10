#!/bin/bash
#Hassan Nov. 29, 2016
#extract chr1-19, convert to bam, and index it later on.


#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH --error=filterdup.err
#SBATCH --output=filterdup.out
#SBATCH -J liver.ChIP.randsample

#1. get list of narrowpeak
find ../4.callpeaks -name "*narrowPeak" \
  | cut -d"/" -f 3 > narrowpeak.list

#2. load modules
module load bioinfo-tools
module load samtools/1.3
module load BEDTools/2.25.0

#3. read list of peaks and generate final list of bamfiles

while read line
do
  echo ${line}

  grep "chr[0-9]" ../4.callpeaks/${line} > ${line}.chr

  bedToBam -i ${line}.chr -g GRCm38.p4.genome.fa.fai.chr1_19 \
    > ${line}.bam

  samtools index ${line}.bam
done < narrowpeak.list

