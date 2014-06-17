cd "D:\AM\FHS550k\ag\snplst"

use "D:\AMH\fhshrsmatchfinal.dta", clear
keep ss
outsheet using hrsmatchss.txt, non noq replace

*** extract the snps for hrs match
!plink --bfile D:\AM\FHS550k\500k --extract hrsmatchss.txt --make-bed --out 500k

insheet using 500k.bim, tab clear
keep v2
save 500ksnps, replace

foreach x of num 1/34 {
use 500ksnps, clear
keep if _n>`x'*2000-2000 & _n<=`x'*2000
outsheet using snp`x'.txt, non noq replace
}
