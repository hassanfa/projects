#!/bin/bash
#Hassan
#June 30, 2016
#run cufflinks for novel transcripts and exclude annotated exons

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 3
#SBATCH -t 2-00:00:00

GTF_PATH='/proj/b2016252/INBOX/data/GTF_GFFs/Human'
GTF_file_exon='gencode.v25.chr_patch_hapl_scaff.annotation.exononly.gtf'
BOWTIE_INDEXr='GRCh38.p7.genome.fa'
REF_PATH='/proj/b2016252/INBOX/data/indexfiles/Human'
SAMPLE_PATH=$1

echo $SAMPLE_PATH

#modules
#module load cufflinks/2.2.1 
#end of module loads

/home/hassanfa/bin/cufflinks -p 3 \
  -b ${REF_PATH}/${BOWTIE_INDEX} \
  -u \
  -M ${GTF_PATH}/${GTF_file_exon} \
  --library-type fr-firststrand \
  -m 30 \
  -s 10 \
  ${SAMPLE_PATH}/accepted_hits.bam \
  -o ${SAMPLE_PATH}/CufflinksOutputNovelRefExonMask

