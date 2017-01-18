#!/bin/bash
#Hassan Jan 17, 2017
#extract lists of genes from merged.gtf file, then calculates gene length and exon count. This is done uing awkExtractNovelGene.awk
#script and oneliners below.

./awkExtractNovelGene.awk \
  merged_asm_novelonly/merged.gtf \
  | awk '$3-$2>199' > merged_asm_novelonly/lincRNA.candidate

#list of genes that are fitlered above are then selected from merged.gtf file.
join -1 1 -2 10 \
  <( cut -f 4 merged_asm_novelonly/lincRNA.candidate | sort) \
  <( cat merged_asm_novelonly/merged.gtf | tr ' ' '\t' | sort -k10) \
  | awk '{for (i=2; i<10; i++)
            printf $i"\t";
          printf $10" "$1" ";
          for (i=11; i<=17; i++) 
            printf $i" ";
          printf $18"\n"}' > merged_asm_novelonly/novellincRNA.candidate.gtf 
