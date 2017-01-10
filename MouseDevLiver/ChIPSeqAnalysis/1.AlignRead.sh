#!/bin/bash
#Hassan Nov 17, 2016
#runs bowtie2 to align ChIP FQ files to ref genome 

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH --error=liver.ChIP.H3K4me3.err
#SBATCH --output=liver.ChIP.H3K4me3.out
#SBATCH -J liver.ChIP.H3K4me3

module load bioinfo-tools
module load bowtie2/2.2.9
module load samtools/1.3

BOWTIE_INDEX=/proj/b2016216/INBOX/data/indexfiles/MusMusculus/GRCm38.p4.genome

while read fname
do
  echo -e "$fname:"
  echo -e "\tunziping"
  gunzip ${fname}.fq.gz
  
  echo -e "\talligning"
  bowtie2 -p 2 \
    -t \
    -x ${BOWTIE_INDEX} \
    ${fname}.fq \
    -S ${fname}.sam \
    2> ${fname}.bowtie2Stat
  
  echo -e "\tsam to bam"
  samtools view -bS ${fname}.sam > ${fname}.bam
  
  echo -e "\tzipping Fastq"
  gzip ${fname}.fq

  echo -e "\tzipping sam"
  gzip ${fname}.sam
  
  echo "done!"
done < liver.ChIP.H3K4me3.list
