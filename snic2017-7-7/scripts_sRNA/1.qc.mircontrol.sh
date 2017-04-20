#!/bin/bash
#Hassan
#Feb 13
#mircontrol for sRNA libraries

#sRNA file list:
fqlist=`cat /crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list`

#run mircontrol
miRC='/crex1/proj/snic2017-7-7/INBOX/src/tools/mircontrol_v0.1/bin/mircontrol.jar'
myDate=`date +'%y%m%d'`

outp=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/mircontrol_${myDate}/"`
mkdir -p ${outp}

logFile=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/mircontrol_${myDate}/run.${myDate}.log"`
cat /dev/null > ${logFile}

java -jar ${miRC} \
  --species hsa \
  ${fqlist} \
  --output-dir ${outp} \
  --write-fasta \
  --force \
  --adapter TGGAATTCTCGGGTGCCAAGG \
  --verbosity-level 10 &> ${logFile}



