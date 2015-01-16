*cd "D:\AM\FHS550k\agcon"
cd /lustre/scr/v/i/victorw/ag/
log using agconpairsall.log, replace

/*
use ag_pairs_all, clear
drop if typef=="rpos"
append using ag_pairs_rp
replace typef=type if typef==""
drop pair type
gen pair=_n
save agconpairsalltype, replace
drop typef
reshape long iid, i(pair) j(ipid)
save agconpairsall, replace
*/
foreach x of num 1/1000 {
  use agconpairsall, clear
  keep if pair>`x'*100-100 & pair<=`x'*100
  savasas using palst/agconpa`x', replace
}
foreach x of num 1001/2137 {
  use agconpairsall, clear
  keep if pair>`x'*100-100 & pair<=`x'*100
  savasas using palst/agconpa`x', replace
}
log close
