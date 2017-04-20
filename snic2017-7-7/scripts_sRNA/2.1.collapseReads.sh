#!/bin/bash
#Hassan
#Feb 21, 2017
#collapse reads for fastq files preferably after cutadapt

#sRNA fastq list
sRNAfqlist='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list'

while read Fname
do
    cutAdFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.fastq\.gz/g'`
    tmpPath=`echo ${cutAdFname} | sed 's/\.ca.fastq.gz//g'`
    
    echo $Fname
    echo $cutAdFname
    echo $tmpPath

    seqcluster collapse \
        --fastq ${cutAdFname} \
        -o ${tmpPath}

    cp ${tmpPath}/*fastq ${tmpPath}.ca.collapse.fastq
    rm -rf ${tmpPath}  

done < ${sRNAfqlist}
