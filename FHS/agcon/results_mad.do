cd "D:\AM\FHS550k\agpn"

*** mad_mixed
usesas using pmx_mad_all.sas7bdat, clear
sort pair
keep pair estimate
rename estimate rho_mad
merge 1:1 pair using agpn_pairs_all, nogen keep(3)
sort pair
save pmx_mad_all, replace

usesas using nmx_mad_all.sas7bdat, clear
sort pair
keep pair estimate
rename estimate rho_mad
merge 1:1 pair using agpn_pairs_all, nogen keep(3)
sort pair
save nmx_mad_all, replace

use pmx_mad_all, clear
merge 1:1 pair using pmx_res_all, nogen keep(3)
gen pn="p"
save pmx_all, replace
use nmx_mad_all, clear
merge 1:1 pair using nmx_res_all, nogen keep(3)
gen pn="n"
save nmx_all, replace

use pmx_all, clear
append using nmx_all
histogram rho_mad, by(typef pn) yscale(range(0 80)) xscale(range(-0.05 .1)) bin(50)
histogram rho_res, by(typef pn) yscale(range(0 80)) xscale(range(-0.05 .1)) bin(50)













/*
keep if typef=="mp"
keep pair estimate stderr probz
save mx_mad_mp, replace
*/
*** figure 5
gen type=cond(typef=="mp",1,cond(typef=="rpos",2,cond(typef=="sp",3,cond(typef=="pc",4,.))))
lab de typ 1 "Married Couples" 2 "Randomly Paired Pairs" 3 "Full Sibling Pairs" 4 "Parent-child Pairs"
lab val type typ
histogram estimate, bin(500) percent by(type, cols(1) b1title("Correlation") note("")) xlabel(0(0.25)1) xsize(4) ysize(3)

*** figure 6
drop typef
keep if inlist(type,1,2)
append using mx_mp
recode type (2=3) (.=2)
lab de typ6 1 "married couples (N=989) without control for population admixture" 2 "married couples (N=989) with control for population admixture" 3 "opposite sex randomly paired pairs (N=20,000) without control"
lab val type typ6
histogram estimate, bin(400) percent by(type, cols(1) b1title("Correlation") note("")) xsize(4) ysize(3)
ta type, sum(estimate)

histogram estimate if typef=="mp" | typef=="rpos", bin(400) percent by(typef, cols(1)) 
bysort typef: sum estimate probz
ttest estimate if typef=="mp" | typef=="rpos", by(typef)


twoway (scatter stderr estimate if estimate<0.8, msymbol(point)), by(typef)
twoway (scatter stderr estimate if typef=="mp" | typef=="rpos", msymbol(point)), by(typef)
ttest stderr if typef=="mp" | typef=="rpos", by(typef)

bootstrap t=r(t), rep(100) si(900) /*saving(bsauto, replace)*/: ttest estimate if typef=="mp" | typef=="rpos", by(typef)


*** rp_mad_mixed
usesas using mx_mad_rp_all.sas7bdat, clear
sort pair
save mx_mad_rp_all, replace

foreach x of num 1/1000 {
use mx_mad_rp_all, clear
sample 989, count
gen sampleid=`x'
save madrp1000\rp`x', replace
}
use madrp1000\rp1, clear
foreach x of num 2/1000 {
append using madrp1000\rp`x'
}
gen type="rp"
save madrp1000\rp, replace

foreach x of num 1/1000 {
use mx_mad_mp, clear
bsample
gen sampleid=`x'
save madmp1000\mp`x', replace
}
use madmp1000\mp1, clear
foreach x of num 2/1000 {
append using madmp1000\mp`x'
}
gen type="mp"
save madmp1000\mp, replace

* mp1000 and rp1000
use madmp1000\mp, clear
append using madrp1000\rp
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
save madmp1000rp1000bs, replace

use madmp1000rp1000bs, clear
bysort sampleid: keep if _n==1
histogram t, bin(100)
histogram p, bin(100)
histogram p_l, bin(100)
histogram p_u, bin(100)


* mp and rp1000
use mx_mad_mp, clear
gen type="mp"
append using madrp1000\rp
gen t=.
gen mu=.
gen p=.
gen p_l=.
gen p_u=.
foreach x of num 1/1000 {
ttest estimate if type=="mp" | (type=="rp" & sampleid==`x'), by(type)
replace t=r(t) if sampleid==`x'
replace mu=r(mu_1)-r(mu_2) if sampleid==`x'
replace p=r(p) if sampleid==`x'
replace p_l=r(p_l) if sampleid==`x'
replace p_u=r(p_u) if sampleid==`x'
}
save madmprp1000bs, replace

use madmprp1000bs, clear
bysort sampleid: keep if _n==1
histogram t, bin(100)
histogram p, bin(100)
histogram p_l, bin(100)
histogram p_u, bin(100)

* mp and rp1000, rho<0.02
use mx_mad_mp, clear
gen type="mp"
append using madrp1000\rp
gen t=.
gen p=.
gen p_l=.
gen p_u=.
foreach x of num 1/1000 {
ttest estimate if (type=="mp" | (type=="rp" & sampleid==`x')) & estimate<, by(type)
replace t=r(t) if sampleid==`x'
replace p=r(p) if sampleid==`x'
replace p_l=r(p_l) if sampleid==`x'
replace p_u=r(p_u) if sampleid==`x'
}
save madmprp1000bs, replace

use madmprp1000bs, clear
bysort sampleid: keep if _n==1
