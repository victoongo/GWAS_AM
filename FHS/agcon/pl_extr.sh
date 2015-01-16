#!/bin/sh
for i in `seq 1 144`

do
 bsub -q hour -o pl_extr${i}.log plink --bfile 500k --extract snp${i}.txt --make-bed --out snp${i}
done