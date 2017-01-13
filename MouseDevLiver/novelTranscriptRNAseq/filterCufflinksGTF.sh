#!/bin/bash
#Hassan, Jan 12, 2017
#filter cufflinks transcript.gtf file through series of seletions
#1. Check if there are any transcripts that are part of multiple geneIDs
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

awk --re-interval -v F="[\t ]" '
  $3=="transcript" && $1~/chr[0-9]/ {
  totTX++
  if ($10~/ENS/ && $12~/ENS/)
    {
    s[1]++;
    if ($14~/0\.0{10}/)
      r[1]++;
    else
      t[1]++;
    }
  else if ($10~/ENS/ && $12~/CUFF/)
    {
    s[2]++;
    if ($14~/0\.0{10}/)
      r[2]++;
    else
      t[2]++;
    }
  else if ($10~/CUFF/ && $12~/ENS/)
    {
    s[3]++;
    if ($14~/0\.0{10}/)
      r[3]++;
    else
      t[3]++;
    }
  else if ($10~/CUFF/ && $12~/CUFF/)
    {
    s[4]++;
    if ($14~/0\.0{10}/)
      r[4]++;
    else
      t[4]++;
    }
  } END {
  for (i = 1; i <= 5; ++i)
    if (!s[i])
      s[i]=0;
  print "total number of transcripts (chr1-19): ",totTX;
  print "Of which..";
  print "\tnumber of ref genes with ref transcript(total, FPKAM>0, FPKM=0): "s[1],t[1],r[1];
  print "\tnumber of ref genes with CUFFid transcript(total, FPKAM>0, FPKM=0): "s[2],t[2],r[2]; 
  print "\tnumber of CUFFid genes with ref transcript(total, FPKAM>0, FPKM=0): "s[3],t[3],r[3]; 
  print "\tnumber of CUFFid genes with CUFFid transcript(total, FPKAM>0, FPKM=0): "s[4],t[4],r[4]; 
  }' $1

awk --re-interval -v F="[\t ]" '
  $3=="exon" && $1~/chr[0-9]/ {
  totEX++
  if ($10~/ENS/ && $12~/ENS/)
    s[1]++;
  else if ($10~/ENS/ && $12~/CUFF/)
    s[2]++;
  else if ($10~/CUFF/ && $12~/ENS/)
    s[3]++;
  else if ($10~/CUFF/ && $12~/CUFF/)
    s[4]++;
  } END {
  for (i = 1; i <= 5; ++i)
    if (!s[i])
      s[i]=0;
  print "total number of exons (chr1-19): ",totEX;
  print "Of which..";
  print "\tnumber of ref genes with ref transcript: "s[1];
  print "\tnumber of ref genes with CUFFid transcript: "s[2];
  print "\tnumber of CUFFid genes with ref transcript: "s[3];
  print "\tnumber of CUFFid genes with CUFFid transcript: "s[4];
  }' $1

#cat transcripts.gtf | awk '$3=="transcript" && $0~/gene_id \"CUFF.*CUFF/' | head | awk --re-interval
#'$14~/[0-9].[0-9]{5,}/ && $14!~/0\.0{5,}/'
