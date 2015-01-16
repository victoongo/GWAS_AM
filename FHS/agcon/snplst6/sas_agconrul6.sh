#!/bin/bash

let i=1
let n=60
let ee=2137
let intvl=6
pname="agconrul"
pn=6

let nm=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )-$(ls ./${pname}${pn}/*.lck | wc -l )
while [ $i -le $ee ]; do
 if [ $nm -lt $n ] ; then
  bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  echo "========== ${i} submitted and nm is $nm =========="
  let i=$i+1
  let nm=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )-$(ls ./${pname}${pn}/*.lck | wc -l )
 else
  echo "---------- ${i} not submitted and nm is $nm ----------"
  let nm=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )-$(ls ./${pname}${pn}/*.lck | wc -l )
 fi
  sleep $intvl
done

let ndat=$(ls ./${pname}${pn}/*.sas7bdat | wc -l )
while [ $ndat -lt $ee ]; do
  let ndat=$(ls ./${pname}${pn}/*.sas7bdat | wc -l )
  sleep 120
done

bsub -q hour -o mergebs.log sas merge.sas