#!/bin/bash

let njobs=$(bjobs -u all -w | grep -i "log/agconrul6_sas" | wc -l )

if [ $njobs -gt 0 ]; then
  for jobid in $(bjobs -u all -w | grep -i "matlab" | cut -d " " -f 1 )
  do
    echo bkill $jobid
  done
fi
exit


echo njobs= $njobs 

if [ "$njobs" == "" ]; then
  echo njobs is missing
fi
