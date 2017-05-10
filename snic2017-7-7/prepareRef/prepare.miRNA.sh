#!/bin/bash
#Hassan
#Feb 21 2017
#prepare miRbase files

# 1. download mirna sequence for v14 from mirbase mature.fa
# wget ftp://mirbase.org/pub/mirbase/14/mature.fa.gz
# mv mature.fa mature.mirbase14.fa
cat mature.mirbase14.fa \
  | tr ' ' '_' \
  | awk 'ORS=NR%2?FS:RS' \
  | tr ' ' '\t' \
  | grep hsa \
  | awk -v OFS="\t" '{gsub("U","T",$2); print}' \
  | sed 's/_Homo.*\t/\t/g' > mature.mirbase14.Homo.fa

# 2. download high-confidence mirna sequence from
# ftp://mirbase.org/pub/mirbase/21/
# mv high_conf_mature.fa.gz high_conf_mature.miR21.fa
cat high_conf_mature.miR21.fa \
  | tr ' ' '_' \
  | awk 'ORS=NR%2?FS:RS' \
  | tr ' ' '\t' \
  | grep hsa \
  | awk -v OFS="\t" '{gsub("U","T",$2); print}' \
  > high_conf_mature.miR21.Homo.fa

# 3. merge mirbase mature.fa (v14) with mirbase highconfident (v21)
# if there is a miRNA with nt<18 it will be removed.

join -a 1 -a 2 \
  <(sort -k1,1 mature.mirbase14.Homo.fa ) \
  <(sort -k1,1 high_conf_mature.miR21.Homo.fa ) \
  | awk -v OFS="\t" '(NF>2 && $2!=$3) {print $1,$3}
                     (NF==2 || $2==$3) {print $1,$2}' \
  | awk 'length($2)>18' \
  | tr '\t' '\n' \
  | awk '{if ($1~/>/) print $1"|miRNA"; else print $0}' > miRNA.v14.v21highconf.Homo.fa

# 4. merge unique sequences into one and keep the smaller miRNA id
cat miRNA.v14.v21highconf.Homo.fa \
  | sed 's/[_|]/\t/g' \
  | cut -f 1 \
  | awk 'ORS=NR%2?FS:RS' \
  | awk '{seq[$2]=$1"#"seq[$2];
          gsub("#>",",",seq[$2]);
         }END{
          for (x in seq)
            print substr(seq[x], 1, length(seq[x])-1)"\t"x
         }' \
  | awk '{
          L=$1;
          gsub(">","",L);
          b=split(L,La,",");
          LaOut=La[1];
          for (i=2; i<=b; i++) {
              if (length(La[i])<length(LaOut))
                LaOut=La[i]};
          print ">"LaOut"|miRNA\t"$2
         }'  \
  |  tr '\t' '\n' > miRNA.v14.v21highconf.Homo.Uniq.fa 

# 5. index fasta files using bowtie

bowtie-build miRNA.v14.v21highconf.Homo.Uniq.fa miRNA.v14.v21highconf.Homo.Uniq &> miRNA.v14.v21highconf.Homo.Uniq.index.log
