cd /lustre/scr/v/i/victorw/ag/snplst
log using /lustre/scr/v/i/victorw/ag/log/res`1'.log, replace
/*
!plink --bfile 500k --extract snp`1'.txt --make-bed --out snp_extr`1'
!plink --bfile snp_extr`1' --recodeA --out snp`1' 
*/
insheet using "snp`1'.raw", names delimiter(" ") clear
drop fid pat mat sex phenotype
foreach x of varlist ss* {
   destring `x', replace ignore(NA)
}
sort iid
savasas using agm`1', replace
/*
merge 1:1 iid using eig, nogen keep(3)
foreach x of varlist ss* {
   egen stdx=std(`x')
   reg stdx eig1-eig7
   drop `x'
   predict `x', r
   drop stdx
   lab var `x'
}
drop eig*
sort iid
savasas using agr`1', replace
*/
log close
