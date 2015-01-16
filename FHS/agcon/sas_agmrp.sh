#!/bin/sh
for i in `seq 1 1`

do
 bsub -q day -o log/sas_agmrp${i}.log sas -sysparm ${i} agmrp.sas -log log/agmrp_sas${i}.log -logparm open=replace
done