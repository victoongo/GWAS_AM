set more off
set matsize 11000
set maxvar 32767
cd "D:\AMH\ag\snplst"

insheet using "D:\AMH\500k.bim", clear
keep v2
preserve
foreach x of num 1/34 {
	restore, preserve
	keep if _n>`x'*2000-2000 & _n<=`x'*2000
	outsheet using snp`x'.txt, non noq replace
}
