#!/bin/bash
# Hassan
# June 25, 2017
# Aggregate TPM for all samples


for i in `cat SamplePath.list | cut -d "/" -f 2`;
do
  awk -v FN=$i 'BEGIN{print "TX\t"FN}NR>1{print $1"\t"$5}' \
    ../${i}/Kallisto/abundance.tsv > ../${i}/Kallisto/${i}.TPM
done

paste ../Sample*/Kallisto/*TPM | \
  awk '{printf $1"\t"; for (i=2; i<NF; i+=2) printf $i"\t"; print $NF}' \
  > Isoform.abundance.TPM
