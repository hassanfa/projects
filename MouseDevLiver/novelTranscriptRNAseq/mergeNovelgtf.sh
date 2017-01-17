#!/bin/bash
#Hassan
#Jan 17, 2017
#Run cuffmerge to merge GTFs

#SBATCH -A snic2016-7-113 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 3-00:00:00

#modules
#module load bioinfo-tools
#module load cufflinks/2.2.1 
#end of module loads

find ../ -name "transcripts.gtf" \
  | fgrep Novel > Cufflinks.Novel.merge.gtf 

GTF_LIST='Cufflinks.Novel.merge.gtf'
REF_SEQ='/proj/b2016216/INBOX/data/indexfiles/MusMusculus/GRCm38.p4.genome.fa'

cuffmerge \
  -p 2 \
  --min-isoform-fraction 0.1 \
  -s ${REF_SEQ} \
  ${GTF_LIST}
