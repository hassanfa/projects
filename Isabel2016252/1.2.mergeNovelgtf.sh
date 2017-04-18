#!/bin/bash
#Hassan
#Jan 17, 2017
#Run cuffmerge to merge GTFs

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 3-00:00:00

#modules
#module load bioinfo-tools
#module load cufflinks/2.2.1 
#end of module loads

GTF_LIST='/proj/b2016252/INBOX/data/IsabelBarragen/Cufflinks.Novelgtf.merge.list'
BOWTIE_INDEX='GRCh38.p7.genome.fa'
REF_PATH='/proj/b2016252/INBOX/data/indexfiles/Human'

cuffmerge \
  -p 2 \
  --min-isoform-fraction 0.1 \
  -s ${REF_PATH}/${BOWTIE_INDEX} \
  ${GTF_LIST}
