#!/bin/bash
# Hassan July 2017
# Extract alignment time in a friendly format

cat /dev/null > AlignTimeMat

for r in 0 0001 001 01 1 
do
  for a in tophat star hisat
  do
    cut -f2- ../alignfile/${a}/${a}.time.e${r} \
    | sed 's/m/\t/g;s/s//g;/^\s*$/d' \
    | awk -v ALN=${a} -v Mrate=${r} \
      'BEGIN{printf ALN"\t0."Mrate"%%\t"}
       NR==1{printf $1*60+$2"\t"}
       NR>1{sum=sum+$1*60+$2;
       }END{printf sum"\n"}' >> AlignTimeMat
  done
done
