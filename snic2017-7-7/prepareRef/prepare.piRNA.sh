#!/bin/bash
#Hassan
#March 24 2017
#prepare piRNA fasta ref

# 1. download piRNA sequence from
#32,046 sequences in fasta format
#Query: piRNA* AND rna_type:"piRNA" AND TAXONOMY:"9606"
cat piRNA_AND_rna_typepiRNA_AND_TAXONOMY9606.fasta \
  |  awk '{if ($0~/>/) {gsub(">","",$1); print ">"$5"_"$1"|piRNA"} 
           else {gsub("U","T",$0); print $0}}' > piRNA.clean.fa

# 2. index fasta files using bowtie
bowtie-build piRNA.clean.fa piRNA.clean &> piRNA.clean.index.log
