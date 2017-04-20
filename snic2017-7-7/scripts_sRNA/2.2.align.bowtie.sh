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

m='500'

while read Fname
do
    CollapseFname=`echo ${Fname} | sed 's/fastq\.gz/ca\.collapse\.fastq/g'`

    echo $CollapseFname
    # 0.1 Align to all small RNAs
    bowtie ${AllsRNARef} ${CollapseFname} \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.AllsRNA.bowtie.m${m}
    mv una.fq una.toBowtie.fq

    # 0.2 Align to all lncRNA/mRNAs
    bowtie ${AlllncRNAmRNARef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.lncRNAmRNA.bowtie.m${m}

    mv una.fq ${CollapseFname}.AllsRNA.AlllncmRNA.Unaligned

    # 1.1 Align to miRNA
    bowtie ${mirnaRef} ${CollapseFname} \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.mirna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.2 Align to tRNA
    bowtie ${trnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.trna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.3 Align to sRNA
    bowtie ${srnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.srna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.4 Align to piRNA
    bowtie ${pirnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.pirna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.5 Align to lncRNA
    bowtie ${lncrnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.lncrna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.6 Align to mRNA
    bowtie ${mrnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.mrna.bowtie.m${m}

    mv una.fq una.toBowtie.fq

    # 1.7 Align to rRNA
    bowtie ${rrnaRef} una.toBowtie.fq \
        -v 0 \
        -m ${m} \
        --best \
        --strata \
        -p 3 \
        --un una.fq &> ${CollapseFname}.rrna.bowtie.m${m}

    mv una.fq ${CollapseFname}.mi_t_s_pi_lnc_m_rRNA.Unaligned

done < ${sRNAfqlist}

