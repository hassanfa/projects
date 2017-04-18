#!/bin/awk -f 

BEGIN { 
  Feature=ARGV[1];
  ARGV[1]="";
  }
$3==Feature && $1~/chr[0-9]/ {
totTX++;
if ($10~/ENS/ && $12~/ENS/)
  {
  s[1]++;
  if ($0~/FPKM \"0\.0000000000\"/)
    r[1]++;
  else
    t[1]++;
  }
else if ($10~/ENS/ && $12~/CUFF/)
  {
  s[2]++;
  if ($0~/FPKM \"0\.0000000000\"/)
    r[2]++;
  else
    t[2]++;
  }
else if ($10~/CUFF/ && $12~/ENS/)
  {
  s[3]++;
  if ($0~/FPKM \"0\.0000000000\"/)
    r[3]++;
  else
    t[3]++;
  }
else if ($10~/CUFF/ && $12~/CUFF/)
  {
  s[4]++;
  if ($0~/FPKM \"0\.0000000000\"/)
    r[4]++;
  else
    t[4]++;
  }
} END {
for (i = 1; i <= 5; ++i)
{
if (!s[i])
  s[i]=0;
if (!t[i])
  t[i]=0;
if (!r[i])
  r[i]=0;
}
print "total number of "Feature"s (chr[0-9]): ",totTX;
print "Of which..";
print "\tnumber of ref genes with ref "Feature"(total, FPKAM>0, FPKM=0): "s[1],t[1],r[1];
print "\tnumber of ref genes with CUFFid "Feature"(total, FPKAM>0, FPKM=0): "s[2],t[2],r[2]; 
print "\tnumber of CUFFid genes with ref "Feature"(total, FPKAM>0, FPKM=0): "s[3],t[3],r[3]; 
print "\tnumber of CUFFid genes with CUFFid "Feature"(total, FPKAM>0, FPKM=0): "s[4],t[4],r[4]; 
}
