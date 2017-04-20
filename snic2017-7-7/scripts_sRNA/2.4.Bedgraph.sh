#!/bin/bash
#Hassan
#Feb 21 2017
#Align collapsed reads first to miRNA ref from mirbase, and then to tRNA ref.

#Parameters
mirnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/miRNA/miRNA.v14.v21highconf.Homo.Uniq'
trnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/tRNA/hg38-tRNAs.col.chr1_22.IsoAntC.uniq.short'
pirnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/piRNA/piRNA.clean'
srnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/othersmallRNAs/smallRNA.clean'
mrnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/mRNA/mRNA.clean'
lncrnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/lncRNA/lncRNA.clean'
rrnaRef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/rRNA/rRNA.clean'
AlllncRNAmRNARef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/RefAllmRNAlncRNA/AllmRNAlncRNA'
AllsRNARef='/crex1/proj/snic2017-7-7/INBOX/IO/ref/RefAllSmallRNAs/AllSmallRNA'
sRNAfqlist='/crex1/proj/snic2017-7-7/INBOX/IO/seqs/sRNA/sRNA.fastq.list'

m='1'
k='1'

while read Fname
do
    CollapseFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.collapse\.fastq/g'`

    # 1.1 Align to miRNA
    bowtie ${mirnaRef} ${CollapseFname} \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> /dev/null 

    mv una.fq una.toBowtie.fq

    # 1.2 Align to tRNA
    bowtie ${trnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        -k 10 \
        -p 3 \
        --un una.fq &> ${CollapseFname}.trna.bowtie.m${m}.k${k} 

    # 1.3 Take aligned file and prepare a pileup bedgraph like output
    join \
        <(cat ${CollapseFname}.trna.bowtie.m${m}.k${k} \
            | grep seq_ \
            | awk -v OFS="\t" '{  split($3,Gn,"|");
                                  gsub(/seq_[0-9]{1,20}_x/,"",$1);
                                  print Gn[1],$1,$4,length($5) }' \
            | sort  -k1,1) \
        <(awk '{  print $0"\t"length($0) }' ${trnaRef}.fa \
            | awk 'ORS=NR%2?FS:RS' \
            | awk '{  gsub(/[>]/,"",$1);
                      split($1,Gn,"|");
                      print Gn[1]"\t"$4}' \
            | sort -k1,1) \
        | tr ' ' '\t' \
        | awk -v OFS="\t" 'BEGIN { print "Gene\talingSeqCount\tStart\tInsLength\tGeneLength" }
                           { $3=$3+1; print $0 }' > ${CollapseFname}.trna.bowtie.m${m}.k${k}.BG
    mv una.fq una.toBowtie.fq

done < ${sRNAfqlist}

