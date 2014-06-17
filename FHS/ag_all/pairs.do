cd "D:\AM\FHS550k\ag"

*** all 4 types of pairs 
use d:\am\fhs550k\grma, clear
drop if type=="rpss" | type=="self"
drop n grm
sample 200000 if type=="rpos", count
sort iid1 iid2
merge 1:1 iid1 iid2 using fpiid, nogen keep(1 3)
rename iid1 iid
rename iid2 iid1
rename iid iid2
sort iid1 iid2
merge 1:1 iid1 iid2 using fpiid, keep(1 4) update nogen
drop if typef=="" & type=="famp"
replace typef="rpos" if typef==""
drop type
order iid1 iid2 typef
gen pair=_n
save ag_pairs_all, replace

use ag_pairs_all, clear
drop typef
reshape long iid, i(pair)
drop _j
save ag_pairs, replace

foreach x of num 1/1140 {
  use ag_pairs, clear
  keep if pair>`x'*200-200 & pair<=`x'*200
  savasas using agp`x', replace
}

*** self
cd "D:\AM\FHS550k\ag"
use D:\AM\grm\grma, clear
keep if type=="self"
drop n grm
sort iid1 iid2
rename type typef
gen pair=_n
save ag_pairs_self, replace


**** 200k rp
cd "D:\AM\FHS550k\ag"
use D:\AM\grm\grma, clear
keep if type=="rpos"
drop n grm
sample 200000, count
order iid1 iid2 typef
gen pair=_n
save ag_pairs_rp, replace

use ag_pairs_rp, clear
drop type
reshape long iid, i(pair)
drop _j
save ag_pairs_rpt, replace

**** mrp
insheet using "..\500k.fam", delimiter(" ") clear
renvars v1-v6 / fid iid fshare mshare sex pheno
keep fid iid sex
sort iid
tempfile 500k
save `500k', replace

use ag_pairs_all, clear
keep if typef=="mp"
drop typef pair
gen pair=_n
reshape long iid, i(pair) j(ipid)
bysort iid: gen n=_n
keep if n==1
keep iid
gen total=1
tempfile temp1
save `temp1', replace

rename iid iid2
joinby total using `temp1'
drop if iid>=iid2
sort iid
merge m:1 iid using demo, nogen keep(1 3)
renvars fid iid sex birthyr / fid1 iid1 sex1 birthyr1
rename iid2 iid
sort iid
merge m:1 iid using demo, nogen keep(1 3)
renvars fid iid sex birthyr / fid2 iid2 sex2 birthyr2
drop if fid1==fid2 | sex1==sex2
gen birthyrd=birthyr1-birthyr2 if sex1==1
replace birthyrd=birthyr2-birthyr1 if sex1==2
drop if birthyrd<-5 | birthyrd>2
keep iid1 iid2
gen pair=_n
save mrp_all, replace

use mrp_all, clear
gen typef="mrp"
gen type=5
replace pair=pair+213800
save mrp, replace

**** merge all pairs (dropping rpos) with 200k
use ag_pairs_all, clear
drop if typef=="rpos"
append using ag_pairs_rp 
gen type=cond(typef=="mp",1,cond(typef=="sp",2,cond(typef=="pc",3,cond(typef=="rpos",4,.))))
sort type
replace pair=_n
append using mrp
save ag_pairs_alln, replace

use ag_pairs_alln, clear
drop typef type
reshape long iid, i(pair)
rename _j ipid
save ag_pairs, replace
savasas using plst\ag_pairs, replace

