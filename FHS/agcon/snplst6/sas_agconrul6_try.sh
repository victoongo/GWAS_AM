#!/bin/bash
# nohup bash sas_test2.sh &
# to kill this run:
# jobs -p
# then copy and paste the number into:
# kill -9 1234

# total 2137

echo "$!"

let b=1
let n=60
let ee=2137
let intvl=10
pname="agconrul"
pn=6

let e=$b-1+$n

for i in `seq $b $e`
 do
  echo bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  sleep $intvl
 done

let j=$b
let i=$e
let try=0
while [ $i -lt $ee ]; do
 if [ -e ./${pname}${pn}/mx_${pname}${j}.sas7bdat.lck ] || [ -e ./${pname}${pn}/mx_${pname}${j}.sas7bdat ] || [ $try = 6 ] ; then
  let try=0
  let j=$j+1 
  let i=$i+1
  echo bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
 else
  let try=$try+1
  echo "${j} does not exist and $(expr $i + 1) not submitted and try number $try"
 fi
  sleep $intvl
done


# let en=35
# let ee=$e+$en