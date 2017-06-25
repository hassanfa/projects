#!/bin/bash
# Hassan
# June 20, 2017
# Run kallisto quant, sam output to bam, and delete sam

#SBATCH -A b2016216 
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 1-00:00:00
#SBATCH --output=isoform.out
#SBATCH --error=isoform.err

#load modules
module load bioinfo-tools
module load kallisto/0.43.0
module load samtools/1.3
#end loat module

while read SAMPLEID
do
  #TODO: remove libraries with short legnth
  
  AVGFG=`zcat ${SAMPLEID}/S*rmrRNA.fastq.gz \
    | awk 'NR%4==2 {sum+=length($1); sumsq+=length($1)^2}END{print sum/NR}'`
  
  STDFG=`zcat ${SAMPLEID}/S*rmrRNA.fastq.gz \
    | awk 'NR%4==2 { sum+=length($1); sumsq+=length($1)^2}END{print sqrt(sumsq/NR-(sum/NR)^2)}'`
  
  echo ${SAMPLEID} ${AVGFG} ${STDFG}

  mkdir -p ${SAMPLEID}/Kallisto
 
  kallisto quant \
    -i Homo_sapiens.GRCh38 \
    --pseudobam \
    --single \
    --rf-stranded \
    -l ${AVGFG} \
    -s ${STDFG} \
    -o ${SAMPLEID}/Kallisto/ ${SAMPLEID}/S*rmrRNA.fastq.gz \
    1> ${SAMPLEID}/Kallisto/abundance.sam \
    2> ${SAMPLEID}/Kallisto/${SAMPLEID}.run.log
  
  samtools view -bS ${SAMPLEID}/Kallisto/abundance.sam \
    > ${SAMPLEID}/Kallisto/abundance.bam
  
  rm ${SAMPLEID}/Kallisto/abundance.sam 
done < SamplePath.list
