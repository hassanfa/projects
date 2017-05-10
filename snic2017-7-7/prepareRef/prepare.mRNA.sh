#!/bin/bash
#Hassan
#March 24 2017
#prepare protein coding mRNA

# 1. download sequence from Biomart
# perl api, XML, and URL are in the following files
# Biomart.Perl.pl
# Biomart.URL
# Biomart.xml
# Genome ref is: DB.EnsembleGenes87.Human.GRCh38.p7
# remove duplicate sequences, keep larger transcript of multitranscript genes
cat martquery_0326170858_451.txt \
  |  awk -v p=0 '{if ($0~/>/) {if (p==1) {p=0; printf "\n"} b=split($0,L,"|"); print L[1]"|"L[b];} 
                  else {printf $0; p=1;}}' \
  | awk 'ORS=NR%2?FS:RS' \
  | awk '{if (length(seq[$2])<=length$2) {seq[$2]=$2; ID[$2]=$1}
         }END{for (i in seq) print ID[i]"\t"seq[i]}' \
  | tr '\t' '\n' > mRNA.clean.fa

# 2. index fasta files using bowtie
bowtie-build mRNA.clean.fa mRNA.clean &> mRNA.clean.index.log
