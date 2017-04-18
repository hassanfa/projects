#!/bin/bash
#Hassan
#Jan 31 2017
#count features

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 3-00:00:00

module load bioinfo-tools
module load subread/1.5.1

BamList=`cat /pica/v4/b2016252_nobackup/IsabelBarragen/aligned_reads_bamfile.list`
fpath='/proj/b2016252/nobackup/IsabelBarragen/IO'

featureCounts \
  -t exon \
  -g gene_id \
  -a ${fpath}/CuffMergeAnalysis/ref.novel.merged.chr1_22.gtf \
  -o ${fpath}/ReadCount/Isabel.readCount.strandReverse \
  $BamList \
  -s 2 \
  -T 2 &> ${fpath}/ReadCount/Isabel.readCount.strandReverse.log
