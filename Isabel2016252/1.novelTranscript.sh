#!/bin/bash
#Hassan Jan 25, 2017
#identify novel transcripts

for i in `cat dir.list`
do
  SAMPLE_ID=`echo $i | sed 's/.*IO\///g'`

  sbatch \
    --error=$i/runcufflinks_novel_refexonmask.${SAMPLE_ID}.err \
    --output=$i/runcufflinks_novel_refexonmask.${SAMPLE_ID}.out \
    -J cufflinks_${SAMPLE_ID} \
    /proj/b2016252/INBOX/data/IsabelBarragen/src/1.1.runcufflinks_novel.sh $i
done
