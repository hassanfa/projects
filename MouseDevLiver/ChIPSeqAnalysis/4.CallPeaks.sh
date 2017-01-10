#!/bin/bash
#Hassan Nov. 29, 2016
#randomsample of larger aligned ChIPseq files to smallest of the same developmental stage

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH --error=filterdup.err
#SBATCH --output=filterdup.out
#SBATCH -J liver.ChIP.randsample

module load python/2.7

#2. Go through dev. stages and random sample from cases based on the smallest
#discard any input that has less read than H3K4me3 file
devStage=`cut -f 4 ../3.randsample/aligned.numread.list | uniq `

for d in ${devStage}
do
  #take lowest number of reads from H3K4me3 at a dev. stage
  fListH3=`awk -v D=$d '$4==D && $3=="H3K4me3"' ../3.randsample/aligned.numread.list \
        | cut -f 1 \
        | cut -d"/" -f 3 \
        | sed 's/\.bed\.log//g'`

  fListInput=`awk -v D=$d '$4==D && $3=="Input"' ../3.randsample/aligned.numread.list \
        | cut -f 1 \
        | sed 's/bed\.log/randSample.bed/g;s/2\.filterdup/3\.randsample/g'`

  for f in ${fListH3}
  do
    
    if [ ! -f ../3.randsample/${f}.randSample.bed ]; then
      fIn=../2.filterdup/${f}
    else
      fIn=../3.randsample/${f}.randSample
    fi
    
    ls -lh ${fIn}.bed
    fOut=`echo ${fIn} \
          | sed 's/liver.*BL6//g' \
          | cut -d"/" -f 3`
    echo ${fOut}
    ${HOME}/bin/macs2 callpeak \
          -t ${fIn}.bed \
          -c ${fListInput} \
          -g mm \
          -n ${fOut} \
          -q 0.01 2> ${fOut}.macscallpeak.log
  done
done 
