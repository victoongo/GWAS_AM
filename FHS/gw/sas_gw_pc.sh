#!/bin/sh
for i in `seq 1 29`

do
 bsub -q day -o sas_gw_pc${i}.log sas -sysparm ${i} gw_pc.sas -log gw_pc_sas${i}.log -logparm open=replace
done