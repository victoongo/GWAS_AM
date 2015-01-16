*cd "D:\AM\FHS550k\agcon"
cd /lustre/scr/v/i/victorw/ag/
log using agconpairs200krp.log, replace

*** 200k each rp pairs 
/*
use ag_pairs_rp, clear
drop type
reshape long iid, i(pair) j(ipid)
save agconpairs200krp, replace
*/
foreach x of num 1/1000 {
  use agconpairs200krp, clear
  keep if pair>`x'*200-200 & pair<=`x'*200
  savasas using prplst/agcon200krp`x', replace
}
log close
