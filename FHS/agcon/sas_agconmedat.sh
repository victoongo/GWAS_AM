#!/bin/sh
for i in `seq 1 1`

do
 bsub -q week -o log/sas_agconmedat${i}.log sas -sysparm ${i} agconmedat.sas -log log/agconmedat_sas${i}.log -logparm open=replace
done