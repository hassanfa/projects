#!/bin/bash -l
#Hassan
#Feb 14, 2017

#SBATCH -A snic2017-7-7 
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 8:00:00
#SBATCH -J ref_GRCh38_bwt
#SBATCH --output=indexGRCh38.out
#SBATCH --error=indexGRCh38.err


bowtie2-build GRCh38.p7.genome.fa GRCh38.p7.genome

tophat2 -G gencode.v25.annotation.gtf --transcriptome-index=gencode.v25.transcripts GRCh38.p7.genome
