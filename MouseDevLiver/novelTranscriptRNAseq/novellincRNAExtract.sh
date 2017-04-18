#!/bin/bash
#Hassan Jan 17, 2017
#extract lists of genes from merged.gtf file, then calculates gene length and exon count. This is done uing awkExtractNovelGene.awk
#script and oneliners below.

fpath='merged_asm_novelRefExonMask'
REF_GTF='/proj/b2016216/INBOX/data/GTF_GFFs/MusMusculus/gencode.vM9.chr_patch_hapl_scaff.annotation.no_rRNA_xmchr.gtf'

echo "extracting novel transctipts with at least 200bp length"
./awkExtractNovelGene.awk \
 ${fpath}/merged.gtf \
  | awk '$5>199' > ${fpath}/lincRNA.candidate

echo "list of genes that are fitlered above are then selected from merged.gtf file."
echo "a GTF file will be prepared here"
join -1 1 -2 10 \
  <( cut -f 4 ${fpath}/lincRNA.candidate | sort) \
  <( cat ${fpath}/merged.gtf | tr ' ' '\t' | sort -k10) \
  | awk '{for (i=2; i<10; i++)
            printf $i"\t";
          printf $10" "$1" ";
          for (i=11; i<=17; i++) 
            printf $i" ";
          printf $18"\n"}' > ${fpath}/novellincRNA.candidate.gtf 

echo "filter novel transcripts within chr1-19"
awk '$1~/chr[0-9]/' ${fpath}/novellincRNA.candidate.gtf \
  > ${fpath}/novellincRNA.candidate.chr1_19.gtf

echo "merge novel gtf with ref GTF file."
cat ${fpath}/novellincRNA.candidate.chr1_19.gtf ${REF_GTF} \
  | sort -k1.4,1.6g \
  > ${fpath}/gencode.vM9.chr_patch_hapl_scaff.annotation.no_rRNA_xmchr.novellincRNA.gtf
