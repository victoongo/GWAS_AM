#!/bin/sh
for i in `seq 1 34`

do
 bsub -M 6 -q day -o gwst${i}.log stata -b do gw_rawtosas.do ${i}
done
