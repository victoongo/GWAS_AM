*cd "D:\AM\FHS550k\agcon"
cd /lustre/scr/v/i/victorw/ag/
log using agconpairs200.log, replace

/*
use ag_pairs_all, clear
*drop if typef=="rpos"
sample 989 if typef=="sp", count
sample 989 if typef=="rpos", count
sample 989 if typef=="pc", count
drop pair
gen pair=_n
save agconpairs989type, replace
drop typef
reshape long iid, i(pair) j(ipid)
save agconpairs989, replace
*/
foreach x of num 1/99 {
  use agconpairs989, clear
  keep if pair>`x'*40-40 & pair<=`x'*40
  savasas using plst/agcon989p`x', replace
}
log close
