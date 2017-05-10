#!/bin/bash
#Hassan
#Feb 21 2017
#prepare tRNA fasta ref

# 1. download tRNA sequence from
#wget http://gtrnadb.ucsc.edu/GtRNAdb2/genomes/eukaryota/Hsapi38/hg38-tRNAs.fa

fname='hg38-tRNAs'

echo "list of chromosomes:"
grep ">" ${fname}.fa | cut -d' ' -f 3 | tr ':' '\t' | cut -f 1 | sort | uniq -c

echo "convert sequence to column"
cat ${fname}.fa \
  | awk -v p=0 '{if ($0~/>/) {if (p==1) {p=0; printf "\n"} print $0;} else {printf $0; p=1;}}' \
  | awk 'ORS=NR%2?FS:RS' > ${fname}.col.fa

echo "tRNA No:"
grep ">" ${fname}.fa | wc

echo "removing chrX, chr1_KI270713v1_random, Und and NNN anticodons"
cat ${fname}.col.fa \
  | grep -v "chr1_KI270713v1_random" \
  | grep -v chrX \
  | grep -v Und \
  | grep -v NNN > ${fname}.col.chr1_22.fa

echo "tRNA No after removing NNN and Und:"
grep ">" ${fname}.col.chr1_22.fa | wc 

echo "convert tRNA names to isotypes and anticodons (discard tRNA IDs)"
cat ${fname}.col.chr1_22.fa \
  | awk '{gsub(/[()]/,"",$6); print ">"$5"_"$6"\t"$11}' > ${fname}.col.chr1_22.IsoAntC.fa

echo "number of lowercase nt in the sequence (i.e. possible introns)."
echo "based on GtRNAdb, there should be 34 with introns"
cat ${fname}.col.chr1_22.IsoAntC.fa \
  | awk 'function repeat( str, n, rep, i ) { for( ; i<n; i++ ) rep = rep str; return rep } 
        $2!~/[a-z]/ {sum[0]+=1}
        {for (i=1; i<=7; i++) {if (match($2,repeat("[a-z]",i))) sum[i]+=1}
        }END{print "Sequences with lowercase(i.e. introns)" 
            for (i=0; i<=7; i++) print i"\t"sum[i]}'

cat ${fname}.col.chr1_22.IsoAntC.fa \
  | awk '{if ($2~/[a-z]{5}/) {gsub(/[a-z]{5,100}/,"",$2); print $1"\t"toupper($2);} else print $1"\t"toupper($2)}' \
  | awk '{seq[$2]=$1"#"seq[$2];
          gsub("Homo_sapiens_","",seq[$2]);
          gsub("#>",",",seq[$2]);
         }END{
          for (x in seq)
            print substr(seq[x], 1, length(seq[x])-1)"\t"x}' \
  | tr '\t' '\n' > ${fname}.col.chr1_22.IsoAntC.uniq.fa

echo "tRNA No after merging identical sequences and removing introns (N_lowercase>=5):"
grep ">" ${fname}.col.chr1_22.IsoAntC.uniq.fa | wc 


awk 'ORS=NR%2?FS:RS' ${fname}.col.chr1_22.IsoAntC.uniq.fa \
  | awk 'function ismember(x,y) {f=0; for (v in x) if (x[v]==y)  {f=1}; return f}
        {L=$1;
        gsub(">","",L);
        b=split(L,La,",");
        c=1;
        U[1]=La[1];
        for (i=2; i<=b; i++) if (ismember(U,La[i])==0) {c+=1; U[c]=La[i]};
        s=">"U[1];
        for (i=2; i<=length(U); i++) s = s "," U[i];
        Sc+=1;
        print s"_"Sc"|tRNA\t"$2}' \
  | tr '\t' '\n' > ${fname}.col.chr1_22.IsoAntC.uniq.short.fa

#blast tRNAs for future reference
module load bioinfo-tools
module load blast/2.6.0+
makeblastdb -in ${fname}.col.chr1_22.IsoAntC.uniq.short.fa \
  -dbtype nucl \
  -out ${fname}.col.chr1_22.IsoAntC.uniq.short.blastdb &> blastdb.make.log 

blastn -query ${fname}.col.chr1_22.IsoAntC.uniq.short.fa \
  -db ${fname}.col.chr1_22.IsoAntC.uniq.short.blastdb \
  -task blastn \
  -outfmt 7 \
  -out ${fname}.col.chr1_22.IsoAntC.uniq.short.fa.blast &> blasttRNA.result.log

# 2. index fasta files using bowtie
bowtie-build ${fname}.col.chr1_22.IsoAntC.uniq.short.fa \
  ${fname}.col.chr1_22.IsoAntC.uniq.short &> ${fname}.col.chr1_22.IsoAntC.uniq.short.fa.index.log
