#!/bin/sh
for i in `seq 1 25`

do
 bsub -q day -o log/sas_madpa${i}.log sas -sysparm ${i} madpa.sas -log log/madpa_sas${i}.log -logparm open=replace
done