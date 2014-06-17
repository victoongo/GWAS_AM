cd "D:\AM\FHS550k\ag"

foreach x of num 1/144 {
use 500ksnps, clear
keep if _n>`x'*2000-2000 & _n<=`x'*2000
outsheet using snplst\snp`x'.txt, non noq replace
}
