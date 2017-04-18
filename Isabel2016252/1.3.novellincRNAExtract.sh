#!/bin/bash
#Hassan Jan 17, 2017
#extract lists of genes from merged.gtf file, then calculates gene length and exon count. This is done uing awkExtractNovelGene.awk
#script and oneliners below.

fpath='/proj/b2016252/INBOX/data/IsabelBarragen/IO/CuffMergeAnalysis'

REFGTF_PATH='/proj/b2016252/INBOX/data/GTF_GFFs/Human'
REF_GTF='gencode.v25.chr_patch_hapl_scaff.annotation.chr1_22_norRNAribozyme.gtf'
BOWTIE_INDEX='GRCh38.p7.genome.fa'
REF_PATH='/proj/b2016252/INBOX/data/indexfiles/Human'

src_PATH='/proj/b2016252/INBOX/data/IsabelBarragen/src'
echo "extracting novel transctipts with at least 200bp length"
${src_PATH}/awkExtractNovelGene.awk \
 ${fpath}/merged.gtf \
  | awk '$3-$2>199' > ${fpath}/lincRNA.candidate

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

echo "filter novel transcripts within chr1-22"
awk '$1~/chr[0-9]/' ${fpath}/novellincRNA.candidate.gtf \
  > ${fpath}/novellincRNA.candidate.chr1_22.gtf


gffread -L ${fpath}/novellincRNA.candidate.chr1_22.gtf -o ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.gff3

gffread -w ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.fa -g ${REF_PATH}/${BOWTIE_INDEX} \
  ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.gff3

cat ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.fa \
  | awk '$0~">"{key=$0} $0!~">"{seq[key]=seq[key]$0}END{for (i in seq) {print i; print seq[i];}}' \
  | awk '$0~">"{printf $0} $0!~">"{print "\t"length($0)}' \
  > ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.fastaLength

cpat.py -g ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.fa \
  -d /proj/b2016216/INBOX/data/CPAT_DB/Human/gencode.v25.logit.RData \
  -x /proj/b2016216/INBOX/data/CPAT_DB/Human/gencode.v25.hexamer.tsv \
  -o ${fpath}/ProteinCodingAnalysis/novellincRNA.codingPotential

join <(gffread ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.gff3 -T -o- \
      | awk '{print $10"\t"$0}' \
      | awk '{gsub(/[\"\;]/,"",$1); print $0}' \
      | sort -k1,1) \
    <(awk '$6<0.344' ${fpath}/ProteinCodingAnalysis/novellincRNA.codingPotential \
      | cut -f 1 \
      | sort) \
    | cut -d' ' -f2- \
    | awk '{for (i=1; i<=8; i++) 
              printf $i"\t";
            print $11" "$12" "$9" "$10}' \
  > ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.noProteinCoding.gtf

echo "merge novel gtf with ref GTF file."
cat ${fpath}/ProteinCodingAnalysis/novellincRNA.candidate.chr1_22.noProteinCoding.gtf ${REFGTF_PATH}/${REF_GTF} \
  | sort -k1.4,1.6g \
  > ${fpath}/ref.novel.merged.chr1_22.gtf
