#!/bin/sh
for i in `seq 1 29`

do
 bsub -q day -o sas_gw_sp${i}.log sas -sysparm ${i} gw_sp.sas -log gw_sp_sas${i}.log -logparm open=replace
done