#!/bin/bash
# Hassan July 2017
# Prepare reference genome

GTFDIR='../refgenome/annotation/'
FASTADIR='../refgenome/fasta/'

mkdir -p $GTFDIR
mkdir -p $FASTADIR

# Download annotation, decompress, put in annotation dir, and select chr19
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M14/gencode.vM14.annotation.gtf.gz
mv gencode.vM14.annotation.gtf.gz ${GTFDIR}
gunzip ${GTFDIR}/gencode.vM14.annotation.gtf.gz
awk '$1=="chr19"' ${GTFDIR}/gencode.vM14.annotation.gtf > ${GTFDIR}/chr19.gtf

# Download reference genome, decompress, put in reference genome directory, index, and select chr19
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M14/GRCm38.p5.genome.fa.gz
mv GRCm38.p5.genome.fa.gz ${FASTADIR}
gunzip ${FASTADIR}/GRCm38.p5.genome.fa.gz

module load bioinfo-tools
module load samtools/1.4

echo "Indexing reference fasta"
samtools faidx ${FASTADIR}/GRCm38.p5.genome.fa

echo "Extract chr19"
samtools faidx ${FASTADIR}/GRCm38.p5.genome.fa chr19 > ${FASTADIR}/chr19.fa

echo "Indexing chr19 fasta"
samtools faidx ${FASTADIR}/chr19.fa

