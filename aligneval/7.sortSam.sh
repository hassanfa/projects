#!/bin/bash
# Hassan July 2017
# sort sam files

module load bioinfo-tools
module load samtools/1.4

for r in 0 0001 001 01 1
do
  for a in tophat star hisat
  do
    samtools sort ../alignfile/${a}/${a}.e${r}.sam -O SAM > ../alignfile/${a}/${a}.e${r}.sorted.sam
  done
done
