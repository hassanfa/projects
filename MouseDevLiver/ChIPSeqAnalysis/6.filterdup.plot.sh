#!/bin/bash
#Hassan Dec 6 2016
#ngsplot for aligned ChIP-seq results

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 3
#SBATCH -t 20:00:00
#SBATCH --error=filterdup.plot.err
#SBATCH --output=filterdup.plot.out
#SBATCH -J liver.filterdup.plot.ChIP

fPath='/proj/b2016216/INBOX/data/RawFastQ/MusMusculus/ChIP_data/Liver/2.filterdup/'
cat /dev/null > main.log
while read line
do
  echo $line >> main.log
  ./6.plotAligned_bed.sh ${line} ${fPath}
  rm *.bam
  rm *.bam.bai
  rm *.bed
done < 2.filterdup.list
