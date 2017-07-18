#!/bin/bash
# Hassan July 2017
# Align reads using tophat2, hisat2, and star
# input is one of these numbers: 0 0001 001 01 1

# Load modules
module load bioinfo-tools
module load star/2.5.3a
module load bowtie2/2.3.2
module load HISAT2/2.1.0
module load tophat/2.1.1
module load samtools/1.4

# fastq files
fq1=`echo -e "../SimFQ/r1.e$1.fq"`
fq2=`echo -e "../SimFQ/r2.e$1.fq"`

echo $fq1
echo $fq2

# tophat2
bwtindex='../indexfiles/bwtindex/chr19'
tophat='../alignfile/tophat/'
mkdir -p $tophat

{ time tophat2 -p 4 -o ${tophat} ${bwtindex} \
  ${fq1} ${fq2} &> ${tophat}tophat.e${1}.log ; } 2> ${tophat}tophat.time.e${1}

mv ${tophat}accepted_hits.bam ${tophat}tophat.e${1}.bam
mv ${tophat}align_summary.txt ${tophat}tophat.summary.e${1}.txt
samtools view -h -o ${tophat}tophat.e${1}.sam ${tophat}tophat.e${1}.bam

# hisat2
hsindex='../indexfiles/hsindex/chr19'
hisat='../alignfile/hisat/'
mkdir -p $hisat

{ time hisat2 -p 4 -x ${hsindex} -q \
  -1 ${fq1} -2 ${fq2} \
  -S ${hisat}hisat.e${1}.sam \
  2> ${hisat}hisat.summary.e${1}.txt \
  1> ${hisat}hisat.e${1}.log ; } 2> ${hisat}hisat.time.e${1}

hisat2 -p 4 -x ${hsindex} -q --dta \
  -1 ${fq1} -2 ${fq2} \
  -S ${hisat}hisat.stringtie.e${1}.sam \
  2> ${hisat}hisat.stringtie.summary.e${1}.txt \
  1> ${hisat}hisat.stringtie.e${1}.log

samtools sort ${hisat}hisat.stringtie.e${1}.sam -O SAM > ${hisat}hisat.stringtie.e${1}.sorted.sam

hisat2 -p 4 -x ${hsindex} -q --dta-cufflinks \
  -1 ${fq1} -2 ${fq2} \
  -S ${hisat}hisat.cufflinks.e${1}.sam \
  2> ${hisat}hisat.cufflinks.summary.e${1}.txt \
  1> ${hisat}hisat.cufflinks.e${1}.log

samtools sort ${hisat}hisat.cufflinks.e${1}.sam -O SAM > ${hisat}hisat.cufflinks.e${1}.sorted.sam

# star aligner
stindex='../indexfiles/stindex/'
star='../alignfile/star/'
mkdir -p $star

{ time star --genomeDir ${stindex} \
  --readFilesIn ${fq1} ${fq2} \
  --outFileNamePrefix ${star} \
  --runThreadN 4 \
  2> ${star}star.e${1}.log ; } 2> ${star}star.time.e${1}

mv ${star}Aligned.out.sam ${star}star.e${1}.sam
mv ${star}Log.final.out ${star}star.summary.e${1}.txt

star --genomeDir ${stindex} \
  --readFilesIn ${fq1} ${fq2} \
  --outFileNamePrefix ${star} \
  --outSAMstrandField intronMotif \
  --runThreadN 4 \
  2> ${star}star.cufflinks.e${1}.log

mv ${star}Aligned.out.sam ${star}star.cufflinks.e${1}.sam
mv ${star}Log.final.out ${star}star.cufflinks.summary.e${1}.txt

samtools sort ${star}star.cufflinks.e${1}.sam -O SAM > ${star}star.cufflinks.e${1}.sorted.sam
