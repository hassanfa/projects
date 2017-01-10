#!/bin/bash

awk -F"\t" '$1 ~ /tags after filtering in alignment file/ {
                                                print FILENAME,$1,FILENAME
                                                }' ../2.filterdup/*log \
  | sed 's/INFO.*file://' \
  | tr -s ' ' \
  | awk '{
        OFS="\t"; \
        gsub("BL6","\t",$3); \
        gsub("_CRI01","\t",$3); \
        gsub("_Input_","\tInput\t",$3); \
        gsub("_H3K4me3_","\tH3K4me3\t",$3);\
        print
        }' \
  | cut -f 1,2,4,6 \
  | sort -k4,4 -k2,2g > aligned.numread.list
