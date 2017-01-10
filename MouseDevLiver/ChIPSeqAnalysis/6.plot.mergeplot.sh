#!/bin/bash
#Hassan
#Dec 7 2016
#merge pdfs for each time point

for i in P29 P22 P4 e15.5 e18.5 P0.5
do
  echo $i
  fList=`find . -name "*H3K4me3*avg*pdf" -size +0 | fgrep $i | sort -t"/" -k3.1,3.6 -k2,2`
  pdfjam $fList --quiet --nup 3x5 --no-landscape --outfile ${i}.H3K4me3.avgprof.pdf
  fList=`find . -name "*H3K4me3*heat*pdf" -size +0 | fgrep $i | sort -t"/" -k3.1,3.6 -k2,2`
  pdfjam $fList --quiet --nup 6x1 --no-landscape --outfile ${i}.H3K4me3.heatmap.pdf
  
  fList=`find . -name "*Input*avg*pdf" -size +0 | fgrep $i | sort -t"/" -k3.1,3.6 -k2,2`
  pdfjam $fList --quiet --nup 3x5 --no-landscape --outfile ${i}.Input.avgprof.pdf
  fList=`find . -name "*Input*heat*pdf" -size +0 | fgrep $i | sort -t"/" -k3.1,3.6 -k2,2`
  pdfjam $fList --quiet --nup 6x1 --no-landscape --outfile ${i}.Input.heatmap.pdf
done
