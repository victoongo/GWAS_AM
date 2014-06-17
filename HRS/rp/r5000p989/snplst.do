set more off
set matsize 11000
set maxvar 32767
cd "D:\AMH\rp\r5000p989"

insheet using "D:\AMH\500k.bim", clear
*drop if v1==23
keep v2
preserve

foreach x of num 1/666 {
	restore, preserve
	keep if _n>`x'*100-100 & _n<=`x'*100
	outsheet using snplst\rp`x'.txt, non noq replace
}
