#!/bin/bash
#Hassan, Jan 12, 2017
#filter cufflinks transcript.gtf file through series of seletions
#1. Check if there are any transcripts that are part of multiple geneIDs
prjPATH='/home/hassanfa/scripts/projects/MouseDevLiver/novelTranscriptRNAseq'

echo ">> Step one: transcript count"
cat $1 | tr ' ' '\t' \
  | cut -f 10,12 | sed 's/[;"]//g' \
  | sort -u | cut -f 2 | sort | uniq -c \
  | rev | cut -d' ' -f 1,2 | rev \
  | awk '
      {
      if ($1>1) 
        {Flag="FAIL"; print $1"\t"$2}
      } END {
      if (!Flag) 
        print "No multi-geneid transcript: PASS"
      }'

${prjPATH}/awkFeatureCount.awk transcript $1 
${prjPATH}/awkFeatureCount.awk exon $1 
${prjPATH}/awkCountGene.awk $1

#cat transcripts.gtf | awk '$3=="transcript" && $0~/gene_id \"CUFF.*CUFF/' | head | awk --re-interval
#'$14~/[0-9].[0-9]{5,}/ && $14!~/0\.0{5,}/'
