#!/bin/bash -l
#Hassan
#Feb 14, 2017

#SBATCH -A snic2017-7-7 
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 8:00:00
#SBATCH -J ref_GRCh38_bwt
#SBATCH --output=indextranscript.out
#SBATCH --error=indextranscript.err


bowtie2-build gencode.v25.transcripts.fa gencode.v25.transcripts
