set maxvar 32767
set matsize 11000

log using /lustre/scr/v/i/victorw/gw/gw`1'.log, replace

*!plink --bfile 500k --extract gw`1'.txt --make-bed --out gw_extr`1'
*!plink --bfile gw_extr`1' --recodeA --out gw`1' 

insheet using /lustre/scr/v/i/victorw/gw/gw`1'.raw, names delimiter(" ") clear
foreach x of varlist rs* {
   destring `x', replace ignore(NA)
   egen c`x'=std(`x')
   replace `x'=c`x'
   drop c`x'
}
describe

savasas using /lustre/scr/v/i/victorw/gw/gw`1'.sas7bdat, replace
log close

