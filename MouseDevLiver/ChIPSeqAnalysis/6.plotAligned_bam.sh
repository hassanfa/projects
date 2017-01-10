module load bioinfo-tools
module load samtools/1.3
module load ngsplot/2.61

fname=`echo -e "$1" | sed 's/liver.*BL6/liver_/;s/_CRI01//'` 
echo $fname

samtools sort $2$1.bam -o ${fname}.sorted.bam
samtools index ${fname}.sorted.bam
samtools view -h ${fname}.sorted.bam | \
  awk 'BEGIN{FS=OFS="\t"}
        (/^@/ &&!/SN:[A-Z]/ && !/SN:chr[A-Z]/) {
                                               print $0
                                               }
        $3~/chr[1-9]/ {
                      print $0
                      }' | \
  samtools view -bh -o ${fname}.sorted.chr1_19.bam -

Gregion='genebody'
Feature='protein_coding'

ngs.plot.r \
  -G mm10 \
  -R ${Gregion} \
  -F ${Feature} \
  -C ${fname}.sorted.chr1_19.bam \
  -O ${fname}.sorted.chr1_19.${Gregion}.${Feature}.ngsplot \
  -T ${fname}_${Gregion}_${Feature} \
  -D refseq \
  -L 3000 \
  -FL 150
