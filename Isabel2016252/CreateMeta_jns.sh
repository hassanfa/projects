#!/bin/bash
#Hassan Dec 16, 2016
#create a metafile, and zcat FQ files in each directory

#SBATCH -A b2016252 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 8:00:00
#SBATCH --error=CreateMeta.err
#SBATCH --output=CreateMeta.out
#SBATCH -J CreateMetaIsabel

FQ_PATH=/proj/b2016252/INBOX/data/IsabelBarragen/FQfiles_concat
BOWTIE_INDEX=/proj/b2016252/INBOX/data/indexfiles/Human/GRCh38.p7.genome
GTF_PATH=/proj/b2016252/INBOX/data/GTF_GFFs/Human/gencode.v25.chr_patch_hapl_scaff.annotation.gtf

srcPATH=/proj/b2016252/INBOX/data/IsabelBarragen

while read dirID
do
  FQname=`find ${srcPATH}/${dirID} | grep 001`
  SAMPLE_ID=${dirID}
  FILE_ID=${dirID}
  OUTPUT_PATH=/proj/b2016252/INBOX/data/IsabelBarragen/${dirID}
  
  echo $dirID
  echo ${FQname}
  echo -e "${FQ_PATH}/${SAMPLE_ID}.fastq"
#  echo "Zcat'_T_'ing..."
#  zcat ${FQname} > ${FQ_PATH}/${SAMPLE_ID}.fastq
#  echo "Gzip'_P_'ing..."
#  gzip ${FQ_PATH}/${SAMPLE_ID}.fastq 
  

cat <<EOF > ${SAMPLE_ID}/${SAMPLE_ID}.meta
SAMPLE_ID=${SAMPLE_ID}
FILE_ID=${FILE_ID}
FQ_PATH=${FQ_PATH}
BOWTIE_INDEX=${BOWTIE_INDEX}
OUTPUT_PATH=${OUTPUT_PATH}
GTF_PATH=${GTF_PATH}
EOF

done < dir.list

