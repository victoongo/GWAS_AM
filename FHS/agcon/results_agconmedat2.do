cd "D:\AM\FHS550k\agcon"

usesas using mx_agconmedat2_all.sas7bdat, clear
*reshape wide rhorul prul rhomed pmed, i(pair) j(col)
sort pair
merge m:1 pair using agconpairsalltype, nogen keep(3)
renvars estimate probz / rhomed pmed
keep pair col colc rhomed pmed typef

la var rhomed "Rho, split by medium"
la def pn 0 "Negative" 1 "Positive"
la val col pn
gen type=cond(typef=="mp",1,cond(typef=="rpos",2,cond(typef=="pc",3,cond(typef=="sp",4,.))))
lab de typ 1 "Married Couples" 2 "Randomly Paired Pairs" 3 "Parent-child Pairs" 4 "Full Sibling Pairs" 
lab val type typ
histogram rhomed if colc==2, bin(200) percent by(type col, col(2) b1title("Correlation") note("")) xlabel(-0.5(0.25)1) xsize(4) ysize(3)

ttest rhomed if col==0 & colc==1 & (typef=="mp" | typef=="rpos"), by(typef)
ttest rhomed if col==0 & colc==2 & (typef=="mp" | typef=="rpos"), by(typef)
ttest rhomed if col==1 & colc==1 & (typef=="mp" | typef=="rpos"), by(typef)
ttest rhomed if col==1 & colc==2 & (typef=="mp" | typef=="rpos"), by(typef)

*** medium split 200krp
usesas using mx_agconmed1t200krp_all.sas7bdat, clear
renvars estimate probz / rhomed pmed
gen typef="rpos"
save mx_agconmed1t200krp_all, replace

usesas using mx_agconmed1t_all.sas7bdat, clear
*reshape wide rhorul prul rhomed pmed, i(pair) j(col)
sort pair
merge m:1 pair using agconpairs989type, nogen keep(3)
renvars estimate probz / rhomed pmed
keep pair col rhomed pmed typef
drop if typef=="rpos"
append using mx_agconmed1t200krp_all
save mx_agconmed1t_all, replace

use mx_agconmed1t_all, clear
keep if typef=="mp"
drop typef
reshape wide rhomed pmed, i(pair) j(col)
save mx_agconmed1t_mp, replace 

use mx_agconmed1t_all, clear
keep if typef=="rpos"
drop typef
reshape wide rhomed pmed, i(pair) j(col)
save mx_agconmed1t_rp, replace 

*** 1000 random draw
foreach x of num 1/1000 {
use mx_agconmed1t_rp, clear
sample 989, count
gen sampleid=`x'
save 1trp1000\rp`x', replace
}
use 1trp1000\rp1, clear
foreach x of num 2/1000 {
append using 1trp1000\rp`x'
}
gen type="rp"
save 1trp1000\rp, replace

foreach x of num 1/1000 {
use mx_agconmed1t_mp, clear
bsample
gen sampleid=`x'
save 1tmp1000\mp`x', replace
}
use 1tmp1000\mp1, clear
foreach x of num 2/1000 {
append using 1tmp1000\mp`x'
}
gen type="mp"
save 1tmp1000\mp, replace

* mp1000 and rp1000 ttest
use 1tmp1000\mp, clear
append using 1trp1000\rp
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
foreach x of num 1/1000 {
ttest rhomed0 if sampleid==`x', by(type)
replace t0=r(t) if sampleid==`x'
replace p0=r(p) if sampleid==`x'
replace p0_l=r(p_l) if sampleid==`x'
replace p0_u=r(p_u) if sampleid==`x'
replace mu0_1=r(mu_1) if sampleid==`x'
replace mu0_2=r(mu_2) if sampleid==`x'

ttest rhomed1 if sampleid==`x', by(type)
replace t1=r(t) if sampleid==`x'
replace p1=r(p) if sampleid==`x'
replace p1_l=r(p_l) if sampleid==`x'
replace p1_u=r(p_u) if sampleid==`x'
replace mu1_1=r(mu_1) if sampleid==`x'
replace mu1_2=r(mu_2) if sampleid==`x'
}
save 1tmp1000rp1000bs, replace

use 1tmp1000rp1000bs, clear
bysort sampleid: keep if _n==1
gen mud0=mu0_1-mu0_2
gen mud1=mu1_1-mu1_2
sum mud0 mud1 p0_u p1_u
lab var mud0 "Mean(Married Pairs) - Mean(Random Pairs), Negative SNPs"
lab var mud1 "Mean(Married Pairs) - Mean(Random Pairs), Positive SNPs"
lab var p0_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Negative SNPs"
lab var p1_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Positive SNPs"

histogram mud0, percent bin(100)
*histogram t0, percent bin(100)
*histogram p0, percent bin(100)
*histogram p0_l, percent bin(100)
histogram p0_u, percent bin(100)

histogram mud1, percent bin(100)
*histogram t1, percent bin(100)
*histogram p1, percent bin(100)
*histogram p1_l, percent bin(100)
histogram p1_u, percent bin(100)


* mp and rp1000 ttest
use mx_agconmed1t_mp, clear
gen type="mp"
append using 1trp1000\rp
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
foreach x of num 1/1000 {
ttest rhomed0 if type=="mp" | (type=="rp" & sampleid==`x'), by(type)
replace t0=r(t) if sampleid==`x'
replace p0=r(p) if sampleid==`x'
replace p0_l=r(p_l) if sampleid==`x'
replace p0_u=r(p_u) if sampleid==`x'
replace mu0_1=r(mu_1) if sampleid==`x'
replace mu0_2=r(mu_2) if sampleid==`x'

ttest rhomed1 if type=="mp" | (type=="rp" & sampleid==`x'), by(type)
replace t1=r(t) if sampleid==`x'
replace p1=r(p) if sampleid==`x'
replace p1_l=r(p_l) if sampleid==`x'
replace p1_u=r(p_u) if sampleid==`x'
replace mu1_1=r(mu_1) if sampleid==`x'
replace mu1_2=r(mu_2) if sampleid==`x'
}
save 1tmprp1000bs, replace

use 1tmprp1000bs, clear
bysort sampleid: keep if _n==1
gen mud0=mu0_1-mu0_2
gen mud1=mu1_1-mu1_2
sum mud0 mud1 p0_u p1_u
lab var mud0 "Mean(Married Pairs) - Mean(Random Pairs), Negative SNPs"
lab var mud1 "Mean(Married Pairs) - Mean(Random Pairs), Positive SNPs"
lab var p0_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Negative SNPs"
lab var p1_u "P-values (Ha: mean(Married Pairs) - mean(Random Pairs) > 0), Positive SNPs"

histogram mud0, percent bin(100)
*histogram t0, percent bin(100)
*histogram p0, percent bin(100)
*histogram p0_l, percent bin(100)
histogram p0_u, percent bin(100)

histogram mud1, percent bin(100)
*histogram t1, percent bin(100)
*histogram p1, percent bin(100)
*histogram p1_l, percent bin(100)
histogram p1_u, percent bin(100)
