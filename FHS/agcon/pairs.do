cd /lustre/scr/v/i/victorw/ag/plst

*** mp and rpos types of pairs 
use ag_pairs_all, clear
drop if typef=="pc" | typef=="sp"
drop typef pair
gen pair=_n
reshape long iid, i(pair)
drop _j
save agpn_pairs, replace
*save agpn_pairs_all, replace

foreach x of num 1/210 {
  use agpn_pairs, clear
  keep if pair>`x'*100-100 & pair<=`x'*100
  savasas using agp`x', replace
}


