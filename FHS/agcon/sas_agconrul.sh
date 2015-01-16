#!/bin/sh
for i in `seq 1 425`

do
 bsub -q day -o log/sas_agconrul${i}.log sas -sysparm ${i} agconrul.sas -log log/agconrul_sas${i}.log -logparm open=replace
done