#!/bin/bash
# Hassan July 2017
# Align statistics from tophat2, hisat2, and star

cat /dev/null > AlignQualMat

for r in 0 0001 001 01 1 
do
  a='tophat'
  awk -v FS=" " -v ALN=${a} -v Mrate=${r} \
    'BEGIN{printf ALN"\t0."Mrate"\t"}
     NR==9 {printf $1"\t"} NR==14 {print $1}' ../alignfile/${a}/${a}.summary.e${r}.txt \
  | awk '{print $1"\t"$2"\t"$4"\t"$3}'  | sed 's/\%//g' >> AlignQualMat

  a='hisat'
  awk -v FS=" " -v ALN=${a} -v Mrate=${r} \
    'BEGIN{printf ALN"\t0."Mrate"\t"}
     NR==4 {printf $2"\t"} NR==15 {print $1}' ../alignfile/${a}/${a}.summary.e${r}.txt \
  | sed 's/[()]//g;s/\%//g' >> AlignQualMat

  a='star'
  cat ../alignfile/${a}/${a}.summary.e${r}.txt | tr -s ' ' \
    | awk -v FS="\t" -v ALN=${a} -v Mrate=${r} \
      'BEGIN{printf ALN"\t0."Mrate"\t"}
       NR==10 {uniqM=$2} NR==25 {multiA=$2} NR==27 {multiB=$2
       }END{print uniqM,multiA+multiB+uniqM}' | sed 's/\%//g'  >> AlignQualMat
done

awk -v FS="\t" '{print $1,$2"%",$3,$4}' AlignQualMat > _tmp_AlignQual
mv _tmp_AlignQual AlignQualMat

