cd "D:\AM\FHS550k\agcon\agmrp"

usesas using mx_agmrp_all.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
*merge m:1 pair using agconpairsalltype, nogen keep(3)
renvars estimate probz / rhorul prul
keep pair rhorul prul 
*qnorm rhorul
*sum if rhorul>0.02
save mx_agmrp_all, replace

usesas using mx_agmp_all.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
*merge m:1 pair using agconpairsalltype, nogen keep(3)
renvars estimate probz / rhorul prul
keep pair rhorul prul 
*qnorm rhorul
save mx_agmp_all, replace

use mx_agmrp_all, clear
la var rhorul "Rho, split by rule"
la def pn 0 "Negative" 1 "Positive"
la val col pn
gen type=cond(typef=="mp",1,cond(typef=="rpos",2,cond(typef=="pc",3,cond(typef=="sp",4,.))))
lab de typ 1 "Married Couples" 2 "Randomly Paired Pairs" 3 "Parent-child Pairs" 4 "Full Sibling Pairs" 
lab val type typ
histogram rhorul, bin(200) percent by(type col, col(2) b1title("Correlation") note("")) xlabel(-0.5(0.25)1) xsize(4) ysize(3)

ttest rhorul if col==0 & (typef=="mp" | typef=="rpos"), by(typef)
ttest rhorul if col==1 & (typef=="mp" | typef=="rpos"), by(typef)
bysort typef : sum rhorul if col==1 & (typef=="mp" | typef=="rpos"), detail
sum rhorul if col==1 & (typef=="rpos") & rhorul<0.65, detail
bysort typef: sum rhorul if col==1 & rhorul<0.65
bysort typef: sum rhorul if col==1 , detail
/*
use mx_agmrp_all, clear
*qnorm rhorul if col==1 & typef=="rpos" & rhorul>0
*histogram rhorul if col==1 & typef=="rpos" & rhorul<0.7
*graph box rhorul if col==1 & typef=="rpos" 
keep if col==1 & typef=="rpos" & (rhorul<0.70 | rhorul>0.745)
keep pair iid1 iid2 rhorul
sort pair
save trblrp, replace
reshape long iid, i(pair) j(ipid)
sort iid
drop rhorul
savasas using trblrp, replace

use mx_agmrp_all, clear
keep if col==1 & typef=="rpos" 
sample 500, count
histogram rhorul
keep pair iid1 iid2 rhorul
sort pair
save trblrp1, replace
reshape long iid, i(pair) j(ipid)
sort iid
drop rhorul
savasas using trblrp1, replace

*/
*** rule split 
use mx_agmp_all, clear
*keep if typef=="mp"
*drop typef
*reshape wide rhorul prul, i(pair) j(col)
save mx_mp, replace 

use mx_agmrp_all, clear
*keep if typef=="rpos"
*drop typef
*reshape wide rhorul prul, i(pair) j(col)
*drop if rhorul<-.0137209 | rhorul>.0272255
save mx_rp, replace 

*** 5*1000 random draw
foreach a of num 1/5 {
 foreach b of num 1/1000 {
  local x=(`a'-1)*1000+`b'
  use mx_rp, clear
  sample 989, count
  gen sampleid=`x'
  save rp1000rul\rp`x', replace
 }
 local y=(`a'-1)*1000+1
 use rp1000rul\rp`y', clear
 foreach b of num 2/1000 {
  local x=(`a'-1)*1000+`b'
  append using rp1000rul\rp`x'
 }
 gen type="rp"
 save rp1000rul\rpa`a', replace
}

foreach a of num 1/5 {
 foreach b of num 1/1000 {
  local x=(`a'-1)*1000+`b'
  use mx_mp, clear
  bsample
  gen sampleid=`x'
  save mp1000rul\mp`x', replace
 }
 local y=(`a'-1)*1000+1
 use mp1000rul\mp`y', clear
 foreach b of num 2/1000 {
  local x=(`a'-1)*1000+`b'
  append using mp1000rul\mp`x'
 }
 gen type="mp"
 save mp1000rul\mpa`a', replace
}

* mp1000 and rp1000 ttest
foreach a of num 1/5  {
 use mp1000rul\mpa`a', clear
 append using rp1000rul\rpa`a'
 gen t1=.
 gen p1=.
 gen p1_l=.
 gen p1_u=.
 gen mu1_1=.
 gen mu1_2=.
 local b=(`a'-1)*1000+1
 local c=(`a')*1000
 foreach x of num `b'/`c' {
  ttest rhorul if sampleid==`x', by(type)
  replace t1=r(t) if sampleid==`x'
  replace p1=r(p) if sampleid==`x'
  replace p1_l=r(p_l) if sampleid==`x'
  replace p1_u=r(p_u) if sampleid==`x'
  replace mu1_1=r(mu_1) if sampleid==`x'
  replace mu1_2=r(mu_2) if sampleid==`x'
 }
 save mp1000rp1000_`a', replace
}

use mp1000rp1000_1, clear
foreach a of num 2/5 {
 append using mp1000rp1000_`a'
}
save mp1000rp1000, replace

use mp1000rp1000, clear
bysort sampleid: keep if _n==1
gen mud1=mu1_1-mu1_2
sum mud1 p1_u
sum p1_u if p1_u<0.05
lab var mud1 "Mean(Married Pairs) - Mean(Random Pairs), Positive SNPs"
lab var p1_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Positive SNPs"

histogram mud1, percent bin(100)
*histogram t1, percent bin(100)
*histogram p1, percent bin(100)
*histogram p1_l, percent bin(100)
histogram p1_u, percent bin(100)







*** rule split 
use mx_agmrp_all, clear
*keep if typef=="rpos"
*drop typef
*reshape wide rhorul prul, i(pair) j(col)
drop if rhorul<-.0137209 | rhorul>.0272255
save mx_agmrp_rps, replace 

*** 1000 random draw
foreach x of num 1/1000 {
use mx_agmrp_rps, clear
sample 989, count
gen sampleid=`x'
save rps1000rul\rp`x', replace
}
use rps1000rul\rp1, clear
foreach x of num 2/1000 {
append using rps1000rul\rp`x'
}
gen type="rp"
save rps1000rul\rp, replace

* mp1000 and rp1000 ttest
use mp1000rul\mp, clear
append using rps1000rul\rp
keep if inrange(sampleid,1,500)
gen t0=.
gen p0=.
gen p0_l=.
gen p0_u=.
gen mu0_1=.
gen mu0_2=.
foreach x of num 1/500 {
ttest rhorul if sampleid==`x', by(type)
replace t0=r(t) if sampleid==`x'
replace p0=r(p) if sampleid==`x'
replace p0_l=r(p_l) if sampleid==`x'
replace p0_u=r(p_u) if sampleid==`x'
replace mu0_1=r(mu_1) if sampleid==`x'
replace mu0_2=r(mu_2) if sampleid==`x'
}
save mp1000mrps1000_1, replace

use mp1000rul\mp, clear
append using rps1000rul\rp
keep if inrange(sampleid,501,1000)
gen t0=.
gen p0=.
gen p0_l=.
gen p0_u=.
gen mu0_1=.
gen mu0_2=.
foreach x of num 501/1000 {
ttest rhorul if sampleid==`x', by(type)
replace t0=r(t) if sampleid==`x'
replace p0=r(p) if sampleid==`x'
replace p0_l=r(p_l) if sampleid==`x'
replace p0_u=r(p_u) if sampleid==`x'
replace mu0_1=r(mu_1) if sampleid==`x'
replace mu0_2=r(mu_2) if sampleid==`x'
}
save mp1000mrps1000_2, replace

use mp1000mrps1000_1, clear
append using mp1000mrps1000_2
save mp1000mrps1000, replace

use mp1000mrps1000, clear
bysort sampleid: keep if _n==1
gen mud0=mu0_1-mu0_2
sum mud0 p0_u
sum if p0_u<0.05
lab var mud0 "Mean(Married Pairs) - Mean(Random Pairs), All SNPs"
lab var p0_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) < 0), All SNPs"

histogram mud0, percent bin(100)
*histogram t0, percent bin(100)
*histogram p0, percent bin(100)
*histogram p0_l, percent bin(100)
histogram p0_u, percent bin(100)