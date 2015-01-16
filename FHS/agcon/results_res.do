cd "D:\AM\FHS550k\agpn"

*** mixed
usesas using pmx_res_all.sas7bdat, clear
sort pair
keep pair estimate
rename estimate rho_res
merge 1:1 pair using agpn_pairs_all, nogen keep(3)
sort pair
save pmx_res_all, replace

usesas using nmx_res_all.sas7bdat, clear
sort pair
keep pair estimate
rename estimate rho_res
merge 1:1 pair using agpn_pairs_all, nogen keep(3)
sort pair
save nmx_res_all, replace

























use ag_pairs_all, clear
sort pair
merge 1:1 pair using mx_all, nogen
/*
keep if typef=="mp"
keep pair estimate stderr probz
save mx_mp, replace
*/

histogram estimate, bin(100) percent by(typef, cols(1)) 
sample 989 if type=="rpos", count
histogram estimate if typef=="mp" | typef=="rpos", normal bin(400) /*percent*/ by(typef, cols(1)) 
bysort typef: sum estimate probz
ttest estimate if typef=="mp" | typef=="rpos", by(typef)


twoway (scatter stderr estimate if estimate<0.8, msymbol(point)), by(typef)
twoway (scatter stderr estimate if typef=="mp" | typef=="rpos", msymbol(point)), by(typef)
ttest stderr if typef=="mp" | typef=="rpos", by(typef)

*** rp_mixed
usesas using mx_rp_all.sas7bdat, clear
sort pair
save mx_rp_all, replace

foreach x of num 1/1000 {
use mx_rp_all, clear
sample 989, count
gen sampleid=`x'
save rp1000\rp`x', replace
}
use rp1000\rp1, clear
foreach x of num 2/1000 {
append using rp1000\rp`x'
}
gen type="rp"
save rp1000\rp, replace

foreach x of num 1/1000 {
use mx_mp, clear
bsample
gen sampleid=`x'
save mp1000\mp`x', replace
}
use mp1000\mp1, clear
foreach x of num 2/1000 {
append using mp1000\mp`x'
}
gen type="mp"
save mp1000\mp, replace

* mp1000 and rp1000
use mp1000\mp, clear
append using rp1000\rp
gen t=.
gen p=.
gen p_l=.
gen p_u=.
foreach x of num 1/1000 {
ttest estimate if sampleid==`x', by(type)
replace t=r(t) if sampleid==`x'
replace p=r(p) if sampleid==`x'
replace p_l=r(p_l) if sampleid==`x'
replace p_u=r(p_u) if sampleid==`x'
}
save mp1000rp1000bs, replace

use mp1000rp1000bs, clear
bysort sampleid: keep if _n==1
histogram t, bin(100)
histogram p, bin(100)
histogram p_l, bin(100)
histogram p_u, bin(100)


* mp and rp1000
use mx_mp, clear
gen type="mp"
append using rp1000\rp
gen t=.
gen p=.
gen p_l=.
gen p_u=.
foreach x of num 1/1000 {
ttest estimate if type=="mp" | (type=="rp" & sampleid==`x'), by(type)
replace t=r(t) if sampleid==`x'
replace p=r(p) if sampleid==`x'
replace p_l=r(p_l) if sampleid==`x'
replace p_u=r(p_u) if sampleid==`x'
}
save mprp1000bs, replace

use mprp1000bs, clear
bysort sampleid: keep if _n==1
histogram t, bin(100)
histogram p, bin(100)
histogram p_l, bin(100)
histogram p_u, bin(100)
