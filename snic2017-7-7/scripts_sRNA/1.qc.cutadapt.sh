#!/bin/bash
#Hassan
#Feb 14 2017
#cut sRNA adapter TGGAATTCTCGGGTGCCAAGG

#SBATCH -A snic2017-7-7 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 3:00:00
#SBATCH -J cutadapt_sRNA 
#SBATCH --output=1.qc.cutadapt.out
#SBATCH --error=1.qc.cutadapt.err

#sRNA fastq list
sRNAfqlist='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list'

while read Fname
do
    logFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.log/g'`
    longFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.long\.fastq\.gz/g'`
    shortFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.short\.fastq\.gz/g'`
    cutAdFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.fastq\.gz/g'`

echo $Fname
echo $logFname
echo $longFname
echo $shortFname
echo $cutAdFname
    cutadapt \
      -e 0.05 \
      -a TGGAATTCTCGGGTGCCAAGG \
      --max-n 0 \
      -m 15 \
      --too-short-output=${shortFname} \
      -o ${cutAdFname} \
      ${Fname} &> ${logFname}
done < ${sRNAfqlist}
#unused option for cutadapter:
      #-g "A{6}" \
      #-M 36 \
      #--too-long-output=${longFname} \
