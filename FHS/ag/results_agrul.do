cd "D:\AM\FHS550k\ag"

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

foreach file in mx_agrul_all /*mx_agrul_cor02*/ {
	foreach sz in 989 /*3474*/ {
		foreach x in rpos mrp {
			/*
			use "`file'", clear
			keep if inlist(typef,"mp","`x'")
			keep rhorul pair col typef
			reshape wide rhorul, i(pair) j(col)
			drop pair
			bootstrap p0_l=r(p_l) mu0_1=r(mu_1) mu0_2=r(mu_2),  rep(5000) size("`sz'") seed(159357) strata(typef) saving(tt0_`x'`sz'`file', replace): ttest rhorul0, by(typef)
			bootstrap p1_u=r(p_u) mu1_1=r(mu_1) mu1_2=r(mu_2),  rep(5000) size("`sz'") seed(159357) strata(typef) saving(tt1_`x'`sz'`file', replace): ttest rhorul1, by(typef)
			*/
			use tt0_`x'`sz'`file', clear
			gen mud0=mu0_1-mu0_2
			sum mud0 p0_l 
			sum p0_l if p0_l<0.05
			use tt1_`x'`sz'`file', clear
			gen mud1=mu1_1-mu1_2
			sum mud1 p1_u
			sum p1_u if p1_u<0.05
		}
	}
}
