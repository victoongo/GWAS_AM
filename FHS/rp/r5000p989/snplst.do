cd "D:\AM\FHS550k\rp\r5000p989"

insheet using "D:\AM\FHS550k\500k.bim", clear
*drop if v1==23
keep v2
rename v2 snp
sort snp
save 500ksnps, replace

foreach x of num 1/959 {
use 500ksnps, clear
keep if _n>`x'*300-300 & _n<=`x'*300
outsheet using snplst\rp`x'.txt, non noq replace
}
