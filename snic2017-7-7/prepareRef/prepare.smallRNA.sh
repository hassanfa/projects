#!/bin/bash
#Hassan
#March 24 2017
#prepare small RNA (excluding piRNA, miRNA, and tRNAs) fasta ref

# 1. download sequence from Biomart
# perl api, XML, and URL are in the following files
# Biomart.Perl.pl
# Biomart.URL
# Biomart.xml
# Genome ref is: DB.EnsembleGenes87.Human.GRCh38.p7
cat martquery_0324133453_112.txt \
  |  awk -v p=0 '{if ($0~/>/) {if (p==1) {p=0; printf "\n"} 
                                  b=split($0,L,"|"); print L[1]"|"L[b];} 
                  else {printf $0; p=1;}}' \
  | awk 'ORS=NR%2?FS:RS' \
  | awk '{if (length(seq[$2])<=length$2) {seq[$2]=$2; ID[$2]=$1}
         }END{for (i in seq) print ID[i]"\t"seq[i]}' \
  | tr '\t' '\n' > smallRNA.clean.fa

# 2. index fasta files using bowtie
bowtie-build smallRNA.clean.fa smallRNA.clean &> smallRNA.clean.index.log
