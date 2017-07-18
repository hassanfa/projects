#!/bin/bash
# Hassan July 2017
# Generate simulated reads for 4 error rates

FQDIR='../SimFQ/'
mkdir -p ${FQDIR}

module load bioinfo-tools
module load samtools/1.4

for i in 1 01 001 0001 0
do
 wgsim -N 200000 \
  -e 0 -r 0.${i} -S 123456789 \
  ../refgenome/fasta/chr19.fa \
  ${FQDIR}r1.e${i}.fq ${FQDIR}r2.e${i}.fq 1> /dev/null
done
