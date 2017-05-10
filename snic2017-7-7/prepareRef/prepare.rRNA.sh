#!/bin/bash
#Hassan
#March 24 2017
#prepare rRNA fasta ref

# 1. download sequence from RNACentral using following query
# query for rrna_AND_TAXONOMY9606_HGNC.fa from RNAcentral:
#  rrna* AND TAXONOMY:"9606" AND rna_type:"rRNA" AND has_genomic_coordinates:"True" AND expert_db:"HGNC"
cat rrna_AND_TAXONOMY9606_HGNC.fa \
  | awk -v p=0 '{if ($0~/>/) {if (p==1) {p=0; printf "\n"} print $1"|rRNA";}
                 else {printf $0; p=1;}}' \
  | tr '\t' '\n' > rRNA.clean.fa

# 2. index fasta files using bowtie
bowtie-build rRNA.clean.fa rRNA.clean &> rRNA.clean.index.log
