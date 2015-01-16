#!/bin/sh
for i in `seq 1 144`

do
 bsub -q hour -o pl_reca${i}.log plink --bfile snp${i} --recodeA --out snp${i} 
done