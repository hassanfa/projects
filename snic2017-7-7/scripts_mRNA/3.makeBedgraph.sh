#/bin/bash
#Hassan May 2017
#Create bedgraph for UCSC

module load bioinfo-tools
module load BEDTools/2.26.0
module load samtools/1.3

cat SampleSheet_mRNA.tsv \
  | awk -v OFS="\t" '{if ($1~/_[1,2]R_/)
                        Side="Right";
                      else Side="Left";
                      if($1~/_1[R,L]_/)
                        Stage="Stage1\t255,30,30\t155,30,30";
                      else Stage="Stage2\t30,30,255\t30,30,155";
                      print $0,Side,Stage}' > SampleSheet_mRNA_color.tsv

while read -r name i Side Stage Colp Coln
do
  echo $i
  for s in "-" "+"
  do
    trackCol=${Colp}
    fname="plus"
    if [ $s == "-" ]
    then
      trackCol=${Coln}
      fname="neg"
    fi

    samtools sort AE1_${i}_L008_R1_001/AE1_${i}_L008_R1_001.bam -o AE1_${i}_L008_R1_001/AE1_${i}_L008_R1_001.sorted.bam

    trackTitle=`echo -e "'name=\"${name}${s}\" visibility=4 color=${trackCol} description=\"${name}\"'"`

    eval bedtools genomecov \
      -ibam AE1_${i}_L008_R1_001/AE1_${i}_L008_R1_001.sorted.bam \
      -bg \
      -split \
      -strand ${s} \
      -trackline \
      -trackopts ${trackTitle} \
    | awk -v OFS="\t" '$0~/chr[0-9]/ || $0~/track/ {if ($4>1) print $0}' \
    > AE1_${i}_L008_R1_001.bam.${fname}.bg.split
    
    eval bedtools genomecov \
      -ibam AE1_${i}_L008_R1_001/AE1_${i}_L008_R1_001.sorted.bam \
      -bg \
      -split \
      -trackline \
      -trackopts ${trackTitle} \
    | awk -v OFS="\t" '$0~/chr[0-9]/ || $0~/track/ {if ($4>1) print $0}' \
    > AE1_${i}_L008_R1_001.bam.all.bg.split
  done
done < SampleSheet_mRNA_color.tsv
