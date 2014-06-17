#!/bin/sh
for i in `seq 1 34`

do
 bsub -q day -M 6 -o log/st_res${i}.log stata -b do res.do ${i}
done
