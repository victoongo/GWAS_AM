*cd "D:\AM\FHS550k\agcon"
cd /lustre/scr/v/i/victorw/ag/
log using agconpairs200.log, replace

/*
use ag_pairs_all, clear
drop if typef=="rpos"
*sample 200 if typef=="mp", count
*sample 989 if typef=="rpos", count
*sample 989 if typef=="pc", count
drop pair
gen pair=_n
save agconpairs200type, replace
drop typef
reshape long iid, i(pair) j(ipid)
save agconpairs200, replace
*/
foreach x of num 1/456 {
  use agconpairs200, clear
  keep if pair>`x'*30-30 & pair<=`x'*30
  savasas using plst/agcon200p`x', replace
}
log close
