#!/bin/bash
# Hassan July 2017
# Prepare reference index file for aligners

chr19='../refgenome/fasta/chr19.fa'

# prepare bowtie2 index
bwtindex='../indexfiles/bwtindex/'

mkdir -p $bwtindex

module load bioinfo-tools
module load bowtie2/2.3.2

cp ${chr19} ${bwtindex}

bowtie2-build --threads 4 \
  ${bwtindex}chr19.fa ${bwtindex}chr19 &> ${bwtindex}bowtie2_build.log 

# prepare HISAT2 index
hsindex='../indexfiles/hsindex/'

mkdir -p $hsindex

module load HISAT2/2.1.0 

cp ${chr19} ${hsindex}

hisat2-build --threads 4 \
  ${hsindex}chr19.fa ${hsindex}chr19 &> ${hsindex}hisat2_build.log

# prepare STAR genome
stindex='../indexfiles/stindex/'

mkdir -p $stindex

module load star/2.5.3a

STAR --runMode genomeGenerate \
  --genomeDir ${stindex} \
  --genomeFastaFiles ${chr19} \
  --runThreadN 4 &> ${stindex}star_genome.log
