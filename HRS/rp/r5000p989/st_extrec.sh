#!/bin/sh
for i in `seq 1 111`

do
 bsub -q hour -o extrec${i}.log stata -b do extrec.do ${i}
done
