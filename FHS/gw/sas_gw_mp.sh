#!/bin/sh
for i in `seq 1 29`

do
 bsub -q day -o sas_gw_mp${i}.log sas -sysparm ${i} gw_mp.sas -log gw_mp_sas${i}.log -logparm open=replace
done