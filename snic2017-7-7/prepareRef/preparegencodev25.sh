#!/bin/bash
#Hassan
#Feb 14, 2017
#beautify gencode into a two column gene_id"\t"gene_type format.
#both tRNA and main annotation

awk '$3=="gene" && $1~/chr[0-9]/' gencode.v25.chr_patch_hapl_scaff.annotation.gtf \
  | awk '{gsub(/[";]/,"",$0); print $10"\t"$12}' > gencode.v25.annotation.list

awk '$1~/chr[0-9]/ {gsub(/[";]/,"",$0); print "tRNA_geneid_"$10"\t"$14}' gencode.v25.tRNAs.gtf >> gencode.v25.annotation.list
