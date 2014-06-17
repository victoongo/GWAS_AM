#!/bin/sh
for i in `seq 1 959`

do
 bsub -q hour -o log/pl_extr${i}.log plink --bfile 500k --extract snplst/rp${i}.txt --make-bed --out snplst/rp${i}
done