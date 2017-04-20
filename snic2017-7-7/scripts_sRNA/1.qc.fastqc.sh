#!/bin/bash
#Hassan
#Feb 13
#fastqc for sRNA libraries

#sRNA file list:
fqlist=`cat /crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list`

#run mircontrol
fqcLoc='/crex1/proj/snic2017-7-7/INBOX/src/tools/FastQC'
myDate=`date +'%y%m%d'`

outp=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/FastQC_${myDate}/"`
mkdir -p ${outp}

logFile=`echo -e "/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/FastQC_${myDate}/run.${myDate}.log"`
cat /dev/null > ${logFile}

adapterseq='/crex1/proj/snic2017-7-7/INBOX/src/scripts/sRNA.adapter.list'

${fqcLoc}/fastqc \
  ${fqlist} \
  --outdir ${outp} \
  --adapter ${adapterseq} &> ${logFile}
