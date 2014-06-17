#!/bin/sh
for i in `seq 321 500`

do
 bsub -q day -o log/sas_rp${i}.log sas -sysparm ${i} rp.sas -log log/rp_sas${i}.log -logparm open=replace
done