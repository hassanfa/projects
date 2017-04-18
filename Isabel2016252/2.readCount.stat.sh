#!/bin/bash
#Hassan
#Feb 13
#summarize readlog from featureCounts

cat Isabel.readCount.summary \
  | sed 's/\///g;s/picav4b2016252INBOXdataIsabelBarragenIO//g;s/accepted_hits\.bam//g' \
  | awk '
    { 
        for (i=1; i<=NF; i++)  {
            a[NR,i] = $i
        }
    }
    NF>p { p = NF }
    END {    
        for(j=1; j<=p; j++) {
            str=a[1,j]
            for(i=2; i<=NR; i++){
                str=str" "a[i,j];
            }
            print str
        }
    }' \
  | tr ' ' '\t' \
  | cut -f 1-5 \
  | sed 's/Status/filename/g'
