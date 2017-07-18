#!/bin/bash
# Hassan July 2017
# _Ab_ _initio_ transcriptome assembly

module load bioinfo-tools
module load StringTie/1.3.3

for r in 0 0001 001 01 1 
do
  echo $r
  for a in tophat star hisat
  do
    echo $a

    # run stringtie
    as='stringtie'
    SAMNAME=${a}.e${r}.sorted.sam
    if [ ${a} == 'hisat' ];
    then
      SAMNAME=${a}.${as}.e${r}.sorted.sam
    fi
    
    OUTDIR='../transcriptAssembly/abinitio/stringtie/'
    mkdir -p $OUTDIR
    
    echo $as

    { time stringtie ../alignfile/${a}/${SAMNAME} \
      -m 30 \
      -p 4 \
      -o ${OUTDIR}stringtie.${a}.e${r}.gtf \
      -A ${OUTDIR}stringtie.${a}.e${r}.abundance \
      &> ${OUTDIR}stringtie.${a}.e${r}.log ; } 2> ${OUTDIR}stringtie.${a}.e${r}.time
    
    # run cufflinks
    as='cufflinks'
    SAMNAME=${a}.e${r}.sorted.sam
    if [ ${a} != 'tophat' ];
    then
      SAMNAME=${a}.${as}.e${r}.sorted.sam
    fi
    
    OUTDIR='../transcriptAssembly/abinitio/cufflinks/'
    mkdir -p $OUTDIR

    echo $as

    { time cufflinks -p 4 -o cufflinks_tmp \
      ../alignfile/${a}/${SAMNAME} &> ${OUTDIR}cufflinks.${a}.e${r}.log ; } 2> ${OUTDIR}cufflinks.${a}.e${r}.time
    
    mv cufflinks_tmp/transcripts.gtf ${OUTDIR}cufflinks.${a}.e${r}.gtf
    mv cufflinks_tmp/genes.fpkm_tracking ${OUTDIR}cufflinks.${a}.e${r}.abundance
    rm -rf ./cufflinks_tmp

  done
done
