#!/bin/sh
for i in `seq 1 100`

do
 bsub -q week -o log/sas100_ag${i}.log sas -sysparm ${i} ag100.sas -log log/ag100_sas${i}.log -logparm open=replace
done