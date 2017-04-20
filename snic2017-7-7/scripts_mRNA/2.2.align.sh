#!/bin/bash
#Hassan
#April 10, 2017
#mRNA align

#SBATCH -A snic2017-7-7 
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 4-00:00:00
#SBATCH -J tophat2_align_mRNA
#SBATCH --output=2.2.align.out
#SBATCH --error=2.2.align.err

#RNA fastq list
RNAfqlist='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/fastq.list'
MainPath='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/'
RefTX='/crex1/proj/snic2017-7-7/INBOX/IO/ref/Genome/gencode.v25.transcripts/gencode.v25.annotation'
GTFref='/crex1/proj/snic2017-7-7/INBOX/IO/ref/Genome/gencode.v25.transcripts/gencode.v25.annotation.gff'
GenomeRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/Genome/GRCh38.p7.genome'

while read Fname
do
    logFname=`echo ${Fname}.tophat2.log`
    ls -lh ${MainPath}/${Fname}/${Fname}.fastq.gz
    tophat2 -p 4 \
      --library-type=fr-firststrand \
      --output-dir=${MainPath}/${Fname} \
      --transcriptome-index=${RefTX} \
      --no-novel-juncs \
      --transcriptome-max-hits=1 \
      --prefilter-multihits \
      --max-multihits=1 \
      --GTF=${GTFref} \
      ${GenomeRef} \
      ${MainPath}/${Fname}/${Fname}.fastq.gz

#echo $Fname
#echo $logFname
done < ${RNAfqlist}
