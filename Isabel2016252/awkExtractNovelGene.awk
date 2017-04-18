#!/bin/awk -f

BEGIN {
  FS="[\t ]";
  OFS="\t";
}
{
  G[$10]++;
  Glen[$10]+=($5-$4);
  Gchr[$10]=$1;
  if (G[$10]>1)
    Gmin[$10] = (Gmin[$10] < $4 ? Gmin[$10] : $4 );
  else 
    Gmin[$10]=$4;
  if (G[$10]>1) 
    Gmax[$10] = (Gmax[$10] > $5 ? Gmax[$10] : $5 );
  else 
    Gmax[$10]=$5
} END {
  for (x in G)
    print Gchr[x] , Gmin[x] , Gmax[x] , x , Glen[x]
}
