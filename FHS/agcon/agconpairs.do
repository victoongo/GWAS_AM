cd "D:\AM\FHS550k\agcon"

*** mp pairs 
use ag_pairs_all, clear
keep if typef=="mp"
drop typef pair
gen pair=_n
reshape long iid, i(pair) j(ipid)
save agconpairs_mp, replace
savasas using agconpairs_mp, replace

*** rp pairs 
use ag_pairs_all, clear
keep if typef=="rpos"
drop typef pair
sample 2046, count
gen pair=_n
reshape long iid, i(pair) j(ipid)
savasas using agconpairs_rp, replace

*** pc pairs 
use ag_pairs_all, clear
keep if typef=="pc"
drop typef pair
sample 2046, count
gen pair=_n
reshape long iid, i(pair) j(ipid)
savasas using agconpairs_pc, replace

*** sp pairs 
use ag_pairs_all, clear
keep if typef=="sp"
drop typef pair
sample 2046, count
gen pair=_n
reshape long iid, i(pair) j(ipid)
savasas using agconpairs_sp, replace
