set maxvar 32767
set matsize 11000

log using /lustre/scr/v/i/victorw/hrs/hrs_0_step.log, replace

***** qc *****
*!plink --bfile CIDR_HRS_filtered --mind 0.05 --geno 0.01 --maf 0.01 --make-bed --out 500kx

***** remove x and other non-autosome and match the fhs *****
insheet using 500kx.bim, tab clear
keep v2
rename v2 rs
sort rs
merge 1:1 rs using match, nogen keep(3)
save 500ksnps, replace
outsheet using 500ksnps.txt, nonames noquote replace
!plink --bfile 500kx --extract 500ksnps.txt --make-bed --out 500k
/*
*** des info for the paper
!plink --bfile 500k --missing --out 500kqc
!plink --bfile 500k --hardy --out 500kqch
!plink --bfile 500k --hardy --nonfounder --out 500kqcha
*/

log close
