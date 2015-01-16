#!/bin/bash

let i=353
let n=60
let ee=2137
let intvl=5
pname="agconrul"
pn=6

let njobs=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )
let nlck=$(ls ./${pname}${pn}/*.lck | wc -l )
let nm=$njobs-$nlck

while [ $i -lt $ee ]; do
 if [ $nm -lt $n ] ; then
  bsub -q day -o log/sas_${pname}${pn}${i}.log sas -sysparm ${i} ${pname}${pn}.sas -log log/${pname}${pn}_sas${i}.log -logparm open=replace
  echo "${i} submitted and nm is $nm"
  let i=$i+1
  let njobs=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )
  let nlck=$(ls ./${pname}${pn}/*.lck | wc -l )
  let nm=$njobs-$nlck
 else
  echo "${i} not submitted and nm is $nm"
  let njobs=$(bjobs -w | grep -i "log/${pname}${pn}_sas" | wc -l )
  let nlck=$(ls ./${pname}${pn}/*.lck | wc -l )
  let nm=$njobs-$nlck
 fi
  sleep $intvl
done

exit

let ndat=$(ls ./${pname}${pn}/*.sas7bdat | wc -l )

while [ $ndat -lt $ee ]; do
  let ndat=$(ls ./${pname}${pn}/*.sas7bdat | wc -l )
  sleep 120
done