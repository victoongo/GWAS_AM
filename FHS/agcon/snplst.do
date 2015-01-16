cd "D:\AM\FHS550k\agcon"

insheet using snplst\500k.bim, clear
drop if v1==23
keep v2
rename v2 snp
sort snp
save 500ksnps, replace

/*
use 500ksnps, clear
merge 1:1 snp using ../gw/550kg, nogen keep(3)
save 500kgsnps, replace
*/

foreach x of num 1/144 {
use 500kgsnps, clear
keep if _n>`x'*2000-2000 & _n<=`x'*2000
outsheet using snplst2\snp`x'.txt, non noq replace
}

usesas using mx_gwmp_all, clear
split snp, p("_")
drop snp2
rename snp snp2
rename snp1 snp
sort snp
merge 1:1 snp using 500ksnps, nogen keep(3)
drop snp
rename snp2 _NAME_
sort _NAME_
savasas using mx_gwmp, replace
