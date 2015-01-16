#!/bin/bash
# nohup bash sas_test2.sh &
# to kill this run:
# jobs -p
# then copy and paste the number into:
# kill -9 1234

# total 2137

echo "$!"

let b=1
let n=50
let ee=2137
let intvl=10
pname="madpa"
pn=

let e=$b-1+$n

for i in `seq $b $e`
 do
  echo bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
# sleep $intvl
 done
