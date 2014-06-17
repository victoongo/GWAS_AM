cd "D:\AM\FHS550k\ag_all"

usesas using mx_agrul_all.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
merge m:1 pair using ag_pairs_alln, nogen keep(3)
renvars estimate probz / rhorul prul
keep pair rhorul prul typef iid1 iid2
sort pair rhorul
by pair: gen col=_n
recode col (1=0) (2=1)
save mx_agrul_all, replace

use mx_agrul_all, clear
la var rhorul "Rho, split by rule"
la def pn 0 "Negative" 1 "Positive"
la val col pn
gen type=cond(typef=="mp",1,cond(typef=="rpos",2,cond(typef=="mrp",3,cond(typef=="pc",4,cond(typef=="sp",5,.)))))
lab de typ 1 "Married Couples" 2 "Permutated Individuals in FHS" 3 "Permutated Individuals in Married Couples" 4 "Parent-child Pairs" 5 "Full Sibling Pairs" 
lab val type typ
histogram rhorul, bin(200) percent by(type col, col(2) b1title("Correlation") note("")) xlabel(-0.5(0.25)1) xsize(4) ysize(3) subtitle(, size(medium))

use mx_agrul_all, clear
la var rhorul "Rho, split by rule"
la def pn 0 "Negative" 1 "Positive"
la val col pn
gen type=cond(typef=="mp",1,cond(typef=="rpos",2,cond(typef=="mrp",3,cond(typef=="pc",4,cond(typef=="sp",5,.)))))
lab de typ 1 "Married Couples" 2 "Permutated Individuals in FHS" 3 "Permutated Individuals in Married Couples" 4 "Parent-child Pairs" 5 "Full Sibling Pairs" 
lab val type typ
histogram rhorul, bin(200) percent by(type col, col(2) b1title("Correlation") note("")) xlabel(-0.5(0.25)1) xsize(4) ysize(3) subtitle(, size(medium))

foreach file in mx_agrul_all /*mx_agrul_cor02*/ {
	foreach sz in 989 /*3474*/ {
		foreach x in rpos mrp {
			
			use "`file'", clear
			keep if inlist(typef,"mp","`x'")
			keep rhorul pair col typef
			reshape wide rhorul, i(pair) j(col)
			drop pair
			*bootstrap p0_l=r(p_l) mu0_1=r(mu_1) mu0_2=r(mu_2),  rep(5000) size("`sz'") seed(159357) strata(typef) saving(tt0_`x'`sz'`file', replace): ttest rhorul0, by(typef)
			bootstrap p1_u=r(p_u) mu1_1=r(mu_1) mu1_2=r(mu_2),  rep(2500) size("`sz'") seed(159357) strata(typef) saving(tt1_`x'`sz'`file', replace): ttest rhorul1, by(typef)
			/*
			use tt0_`x'`sz'`file', clear
			gen mud0=mu0_1-mu0_2
			sum mud0 p0_l 
			sum p0_l if p0_l<0.05
			use tt1_`x'`sz'`file', clear
			gen mud1=mu1_1-mu1_2
			sum mud1 p1_u
			sum p1_u if p1_u<0.05*/
		}
	}
}







*/
*** rule split 
use mx_agrul_all, clear
keep if typef=="mp"
drop typef
reshape wide rhorul prul, i(pair) j(col)
save mx_mp, replace 

use mx_agrul_all, clear
keep if typef=="rpos"
drop typef
reshape wide rhorul prul, i(pair) j(col)
save mx_rp, replace 

use mx_agrul_all, clear
keep if typef=="mrp"
drop typef
reshape wide rhorul prul, i(pair) j(col)
save mx_mrp, replace 

*** 5*1000 random draw
foreach a of num 1/5 {
 foreach b of num 1/1000 {
  local x=(`a'-1)*1000+`b'
  use mx_mp, clear
  bsample
  gen sampleid=`x'
  save mp5000rul\mp`x', replace
 }
 local y=(`a'-1)*1000+1
 use mp5000rul\mp`y', clear
 foreach b of num 2/1000 {
  local x=(`a'-1)*1000+`b'
  append using mp5000rul\mp`x'
 }
 gen type="mp"
 save mp5000rul\mpa`a', replace
}

foreach a of num 1/5 {
 foreach b of num 1/1000 {
  local x=(`a'-1)*1000+`b'
  use mx_rp, clear
  sample 989, count
  gen sampleid=`x'
  save rp5000rul\rp`x', replace
 }
 local y=(`a'-1)*1000+1
 use rp5000rul\rp`y', clear
 foreach b of num 2/1000 {
  local x=(`a'-1)*1000+`b'
  append using rp5000rul\rp`x'
 }
 gen type="rp"
 save rp5000rul\rpa`a', replace
}

use mx_mrp, clear
preserve
foreach a of num 1/5 {
 foreach b of num 1/1000 {
  local x=(`a'-1)*1000+`b'
  restore, preserve
  sample 989, count
  gen sampleid=`x'
  save mrp5000rul\mrp`x', replace
 }
 local y=(`a'-1)*1000+1
 use mrp5000rul\mrp`y', clear
 foreach b of num 2/1000 {
  local x=(`a'-1)*1000+`b'
  append using mrp5000rul\mrp`x'
 }
 gen type="mrp"
 save mrp5000rul\mrpa`a', replace
}

* mp5000 and rp5000 ttest
foreach a of num 1/5  {
 use mp5000rul\mpa`a', clear
 append using rp5000rul\rpa`a'
 gen t0=.
 gen p0=.
 gen p0_l=.
 gen p0_u=.
 gen mu0_1=.
 gen mu0_2=.
 gen t1=.
 gen p1=.
 gen p1_l=.
 gen p1_u=.
 gen mu1_1=.
 gen mu1_2=.
 local b=(`a'-1)*1000+1
 local c=(`a')*1000
 foreach x of num `b'/`c' {
  ttest rhorul0 if sampleid==`x', by(type)
  replace t0=r(t) if sampleid==`x'
  replace p0=r(p) if sampleid==`x'
  replace p0_l=r(p_l) if sampleid==`x'
  replace p0_u=r(p_u) if sampleid==`x'
  replace mu0_1=r(mu_1) if sampleid==`x'
  replace mu0_2=r(mu_2) if sampleid==`x'

  ttest rhorul1 if sampleid==`x', by(type)
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
gen mud0=mu0_1-mu0_2
gen mud1=mu1_1-mu1_2
sum mud0 mud1 p0_l p1_u
sum p0_l if p0_l<0.05
sum p1_u if p1_u<0.05
lab var mud0 "Mean(Married Pairs) - Mean(Random Pairs), Negative SNPs"
lab var mud1 "Mean(Married Pairs) - Mean(Random Pairs), Positive SNPs"
lab var p0_l "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) < 0), Negative SNPs"
lab var p1_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Positive SNPs"

histogram mud0, percent bin(100)
*histogram t0, percent bin(100)
*histogram p0, percent bin(100)
*histogram p0_l, percent bin(100)
histogram p0_l, percent bin(100)

histogram mud1, percent bin(100)
*histogram t1, percent bin(100)
*histogram p1, percent bin(100)
*histogram p1_l, percent bin(100)
histogram p1_u, percent bin(100)


* mp5000 and mrp5000 ttest
foreach a of num 1/5  {
 use mp5000rul\mpa`a', clear
 append using mrp5000rul\mrpa`a'
 gen t0=.
 gen p0=.
 gen p0_l=.
 gen p0_u=.
 gen mu0_1=.
 gen mu0_2=.
 gen t1=.
 gen p1=.
 gen p1_l=.
 gen p1_u=.
 gen mu1_1=.
 gen mu1_2=.
 local b=(`a'-1)*1000+1
 local c=(`a')*1000
 foreach x of num `b'/`c' {
  ttest rhorul0 if sampleid==`x', by(type)
  replace t0=r(t) if sampleid==`x'
  replace p0=r(p) if sampleid==`x'
  replace p0_l=r(p_l) if sampleid==`x'
  replace p0_u=r(p_u) if sampleid==`x'
  replace mu0_1=r(mu_1) if sampleid==`x'
  replace mu0_2=r(mu_2) if sampleid==`x'

  ttest rhorul1 if sampleid==`x', by(type)
  replace t1=r(t) if sampleid==`x'
  replace p1=r(p) if sampleid==`x'
  replace p1_l=r(p_l) if sampleid==`x'
  replace p1_u=r(p_u) if sampleid==`x'
  replace mu1_1=r(mu_1) if sampleid==`x'
  replace mu1_2=r(mu_2) if sampleid==`x'
 }
 save mp1000mrp1000_`a', replace
}

use mp1000mrp1000_1, clear
foreach a of num 2/5 {
 append using mp1000mrp1000_`a'
}
save mp1000mrp1000, replace

use mp1000mrp1000, clear
bysort sampleid: keep if _n==1
gen mud0=mu0_1-mu0_2
gen mud1=mu1_1-mu1_2
sum mud0 mud1 p0_l p1_u
sum p0_l if p0_l<0.05
sum p1_u if p1_u<0.05
lab var mud0 "Mean(Married Pairs) - Mean(Random Pairs), Negative SNPs"
lab var mud1 "Mean(Married Pairs) - Mean(Random Pairs), Positive SNPs"
lab var p0_l "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) < 0), Negative SNPs"
lab var p1_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Positive SNPs"

histogram mud0, percent bin(100)
*histogram t0, percent bin(100)
*histogram p0, percent bin(100)
*histogram p0_l, percent bin(100)
histogram p0_l, percent bin(100)

histogram mud1, percent bin(100)
*histogram t1, percent bin(100)
*histogram p1, percent bin(100)
*histogram p1_l, percent bin(100)
histogram p1_u, percent bin(100)
