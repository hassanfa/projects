gffread -L ../novellincRNA.candidate.chr1_22.gtf -o novellincRNA.candidate.chr1_22.gff3

gffread -w novellincRNA.candidate.chr1_22.fa -g ../../../../indexfiles/Human/GRCh38.p7.genome.fa \
  novellincRNA.candidate.chr1_22.gff3

cat novellincRNA.candidate.chr1_22.fa \
  | awk '$0~">"{key=$0} $0!~">"{seq[key]=seq[key]$0}END{for (i in seq) {print i; print seq[i];}}' \
  | awk '$0~">"{printf $0} $0!~">"{print "\t"length($0)}' > novellincRNA.candidate.chr1_22.fastaLength

cpat.py -g novellincRNA.candidate.chr1_22.fa \
  -d /proj/b2016216/INBOX/data/CPAT_DB/Human/gencode.v25.logit.RData \
  -x /proj/b2016216/INBOX/data/CPAT_DB/Human/gencode.v25.hexamer.tsv \
  -o novellincRNA.codingPotential

join <(gffread novellincRNA.candidate.chr1_22.gff3 -T -o- \
      | awk '{print $10"\t"$0}' \
      | awk '{gsub(/[\"\;]/,"",$1); print $0}' \
      | sort -k1,1) \
    <(awk '$6<0.344' novellincRNA.codingPotential \
      | cut -f 1 \
      | sort) \ 
    | cut -d' ' -f2- \
    | awk '{for (i=1; i<=8; i++) 
              printf $i"\t";
            for (i=9; i<=11; i++)
              printf $i" ";
            print $12}' \
  > novellincRNA.candidate.chr1_22.noProteinCoding.gtf

