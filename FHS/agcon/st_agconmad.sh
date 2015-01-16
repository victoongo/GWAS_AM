#!/bin/sh
for i in `seq 1 144`

do
 bsub -q day -o log/st_agconmad${i}.log stata -b do agconmad.do ${i}
done
