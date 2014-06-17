#!/bin/sh
for i in `seq 1 959`

do
 bsub -q hour -o log/pl_reca${i}.log plink --bfile snplst/rp${i} --recodeA --out snplst/rp${i} 
done