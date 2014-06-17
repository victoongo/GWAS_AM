#!/bin/sh
for i in `seq 1 100`

do
 bsub -q week -o log/sas100_agrul${i}.log sas -sysparm ${i} agrul100.sas -log log/agrul100_sas${i}.log -logparm open=replace
done