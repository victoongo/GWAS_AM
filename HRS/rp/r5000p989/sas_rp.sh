#!/bin/sh
for i in `seq 1 111`

do
 bsub -q week -M 10 -o log/sas_rp${i}.log sas -sysparm ${i} rp.sas -log log/rp_sas${i}.log -logparm open=replace
done