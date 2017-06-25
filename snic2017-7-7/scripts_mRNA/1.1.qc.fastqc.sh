#!/bin/bash
#Hassan
#Feb 13
#fastqc for mRNA libraries

module load bioinfo-tools
module load FastQC

#mRNA file list:
fqlist=`cat /crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/RNA.fastq.list`

myDate=`date +'%y%m%d'`

outp=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/FastQC_${myDate}/"`
mkdir -p ${outp}

logFile=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/RNA/FastQC_${myDate}/run.${myDate}.log"`
cat /dev/null > ${logFile}


fastqc \
  ${fqlist} \
  --outdir ${outp} &> ${logFile}
