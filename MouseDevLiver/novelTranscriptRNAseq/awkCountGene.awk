#!/bin/awk -f
BEGIN { FS="[\t ]"; }
$1~/chr[0-9]/ && $3=="transcript" {
  gsub("[;\"]","",$0);
  G[$10]++; T[$12]++;
} END {
  for (i in G)
    {LG++};
  for (i in T)
    {LT++};
  print "Number of unique genes: "LG;
  print "Number of unique transcripts: "LT;
  print "Average number of transcript per gene: "LT/LG
  }
