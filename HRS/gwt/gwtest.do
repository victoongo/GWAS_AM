set more off
set maxvar 32767
set matsize 11000
cd d:\amh\gwt

use ..\fhshrtmatchfinal, clear
sample 10, count
save fhshrssnp10, replace
use fhshrssnp10, clear
outsheet using fhshrssnp10.txt, nonames noquote replace
keep ss
outsheet using fhssnp10.txt, nonames noquote replace
use fhshrssnp10, clear
keep rs
outsheet using hrssnp10.txt, nonames noquote replace
!plink --bfile D:\AM\FHS550k\500k --extract fhssnp10.txt --make-bed --out fhssnp10
!plink --bfile ..\500k --extract hrssnp10.txt --make-bed --out hrssnp10
!plink --bfile hrssnp10 --update-map fhshrssnp10.txt --update-name --make-bed --out hrssnp10ss 
!plink --bfile fhssnp10 --recodeA --out fhssnp10
!plink --bfile hrssnp10ss --recodeA --out hrssnp10ss

foreach y in fhssnp10 hrssnp10ss {
	insheet using `y'.raw, names delimiter(" ") clear
	foreach x of varlist ss* {
	   destring `x', replace ignore(NA)
	   egen c`x'=std(`x')
	   replace `x'=c`x'
	   drop c`x'
	}
	savasas using `y'.sas7bdat, replace
}

!"C:\Program Files\SASHome\SASFoundation\9.3\sas.exe" -SYSIN "D:\AMH\gwt\gw_mpt.sas" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.3\nls\en\sasv9.cfg" -log gw_mp_sas.log -logparm open=replace


