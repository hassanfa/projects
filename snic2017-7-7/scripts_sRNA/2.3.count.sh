#!/bin/bash
#Hassan
#Feb 21 2017
#Count aligned reads

#Parameters
sRNAfqlist='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list'

m='500'
while read Fname
do
  CollapseFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.collapse\.fastq/g'`
  CountFname=${CollapseFname}.Count.m${m} 
  cat /dev/null > ${CountFname}

  echo $CollapseFname
  for i in mirna trna srna rrna pirna mrna lncrna
  do
    cat ${CollapseFname}.${i}.bowtie.m${m} \
      | grep -v reads | head -n-1 \
      | sed 's/_x/\t/' \
      | cut -f2,4 \
      | awk '{sum[$2]+=$1;
             }END{
             for (i in sum)
                print i"\t"sum[i]
             }' \
      | tr '|' '\t' >> ${CountFname} 
  done
done < ${sRNAfqlist}

