cd "D:\AMH\ag"

usesas using mx_ag_all.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
merge m:1 pair using ag_pairs_all, nogen keep(3)
renvars estimate probz / rho p
keep pair rho p typef iid1 iid2
/*
merge m:1 pair using pair_hcor, nogen keep(1)
drop type
save mx_ag_cor02, replace
*/
save mx_ag_all, replace

use mx_ag_all, clear
la var rho "Rho"
gen type=cond(typef=="mp",1,cond(typef=="rp",2,cond(typef=="mrp",3,cond(typef=="pc",4,cond(typef=="sp",5,.)))))
lab de typ 1 "Married Couples" 2 "Permutated Individuals in HRS" 3 "Permutated Individuals in Married Couples" 4 "Parent-child Pairs" 5 "Full Sibling Pairs" 
lab val type typ
keep if type<=3
ta typef, sum(rho)
ttest rho if typef=="mp" | typef=="mrp", by(typef)
ttest rho if typef=="mp" | typef=="rp", by(typef)
/*
drop if inrange(rho,-.02,0.02)
keep pair
sort pair
save pair_hcor, replace
*/
histogram rho, bin(500) percent by(type, col(1) b1title("Correlation") note("")) xlabel(0(0.05)0.1) xsize(4) ysize(3) subtitle(, size(medium))
histogram rho if rho<0.05 & rho>-0.02, bin(200) percent by(type, cols(1) b1title("Correlation") note("")) xsize(4) ysize(3)

foreach file in mx_ag_all {
	foreach sz in 989 3474 {
		foreach x in rp mrp {
			/*
			use "`file'", clear
			keep if inlist(typef,"mp","`x'")
			keep rho pair typef
			drop pair
			bootstrap p_l=r(p_l) p_u=r(p_u) mu_1=r(mu_1) mu_2=r(mu_2),  rep(5000) size("`sz'") seed(159357) strata(typef) saving(tt_`x'`sz'`file', replace): ttest rho, by(typef)
			*/
			use tt_`x'`sz'`file', clear
			gen mud=mu_1-mu_2
			sum mud p_l p_u 
			sum p_l if p_l<0.05
			sum p_u if p_u<0.05
			
		}
	}
}

foreach file in mx_ag_cor02 {
	foreach sz in 989 3391 {
		foreach x in rp mrp {
			/*
			use "`file'", clear
			keep if inlist(typef,"mp","`x'")
			keep rho pair typef
			drop pair
			bootstrap p_l=r(p_l) p_u=r(p_u) mu_1=r(mu_1) mu_2=r(mu_2),  rep(5000) size("`sz'") seed(159357) strata(typef) saving(tt_`x'`sz'`file', replace): ttest rho, by(typef)
			*/
			use tt_`x'`sz'`file', clear
			gen mud=mu_1-mu_2
			sum mud p_l p_u 
			sum p_l if p_l<0.05
			sum p_u if p_u<0.05
			
		}
	}
}
