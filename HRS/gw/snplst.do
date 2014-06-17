set maxvar 32767
set matsize 11000
cd d:\amh\gw

*** create snplst for gw
foreach x of num 1/34 {
	use ..\500ksnps, clear
	keep if _n>`x'*2000-2000 & _n<=`x'*2000
	outsheet using snplst\gw`x'.txt, non noq replace
}
