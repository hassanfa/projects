module load bioinfo-tools
module load samtools/1.3
module load ngsplot/2.61
module load BEDTools/2.25.0

fname=`echo -e "$1" | sed 's/liver.*BL6/liver_/;s/_CRI01//'` 
echo $fname

grep "chr[0-9]" $2$1.bed > ${fname}.chr1_19.bed

bedToBam -i ${fname}.chr1_19.bed \
  -g GRCm38.p4.genome.fa.fai.chr1_19\
  > ${fname}.chr1_19.bam

samtools sort ${fname}.chr1_19.bam -o ${fname}.chr1_19.sorted.bam
samtools index ${fname}.chr1_19.sorted.bam

Gregion='genebody'
Feature='protein_coding'

ngs.plot.r \
  -G mm10 \
  -R ${Gregion} \
  -F ${Feature} \
  -C ${fname}.chr1_19.sorted.bam \
  -O ${fname}.chr1_19.sorted.${Gregion}.${Feature}.ngsplot \
  -T ${fname}_${Gregion}_${Feature} \
  -D refseq \
  -L 3000 \
  -FL 150
