#!/bin/bash
#Hassan
#April 10, 2017
#read Count

#SBATCH -A snic2017-7-7 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J count_mRNA
#SBATCH --output=2.3.readCount.out
#SBATCH --error=2.3.readCount.err

#RNA fastq list
MainPath='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/'
GTFref='/crex1/proj/snic2017-7-7/INBOX/IO/ref/Genome/gencode.v25.transcripts/gencode.v25.annotation.gff'
BamList='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/alignedBam.list'

module load bioinfo-tools
module load subread/1.5.2

BamList=`cat ${BamList}`

featureCounts \
  -t exon \
  -g gene_id \
  -a ${GTFref} \
  -o ${MainPath}/RNA.readCount.strandReverse \
  $BamList \
  -s 2 \
  -T 2 &> ${MainPath}/RNA.readCount.strandReverse.log
