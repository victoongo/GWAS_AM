cd d:\am\FHS550k\

insheet using "500k.fam", delimiter(" ") clear
rename v1 fid
rename v2 shareid
rename v3 fshare
rename v4 mshare
rename v5 sex
rename v6 pheno
sort shareid
save 500k_fam1, replace

***** create sas file for 5000 rp creation *****
use 500k_fam1, clear
rename shareid iid
keep fid iid
savasas using "rp\fidiid500k.sas7bdat", replace
*** run SAS to create the 5000 random pairs
!"C:\Program Files\SASHome\SASFoundation\9.3\sas.exe" -SYSIN "D:\AM\FHS550k\rp\rp_gen5000.sas" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.3\nls\en\sasv9.cfg"

***** pairdef mp *****
use fshare mshare using 500k_fam1, clear
drop if fshare==0 | mshare==0
bysort fshare mshare: gen n=_n
keep if n==1
drop n
rename fshare shareid
sort shareid
merge m:1 shareid using 500k_fam1, keepusing(shareid) nogen keep(3)
rename shareid iid1
rename mshare shareid
sort shareid
merge m:1 shareid using 500k_fam1, keepusing(shareid) nogen keep(3)
rename shareid iid2
gen fm=_n
reshape long iid, i(fm)
drop _j
save 500k_mp, replace

use 500k_mp, clear
sort iid
savasas using mp, replace

***** pairdef sp *****
cd d:\am\FHS550k\

use shareid fshare mshare using "500k_fam1.dta", clear
drop if fshare==0 | mshare==0
bysort fshare mshare: egen c1=count(fshare)
drop if c1==1
bysort fshare mshare: gen n=_n
gen sib=_n-n
rename shareid iid
keep sib iid
save 500k_sp_t, replace

sort sib iid
by sib: gen n=_n
reshape wide iid, i(sib) j(n)
sort sib
save 500k_sp_w, replace

use 500k_sp_t, clear
sort sib
merge sib using 500k_sp_w
drop _merge
rename iid iidx
reshape long iid, i(iidx) j(n)
drop n
drop if iid==. | iid<=iidx
renvars iid iidx \ iid1 iid2
replace sib=_n 
reshape long iid, i(sib) j(n)
drop n
sort iid
save 500k_sp, replace
!del 500k_sp_t.dta 500k_sp_w.dta

use 500k_sp, clear
sort iid
savasas using sp, replace

***** pairdef pc *****
cd d:\am\FHS550k\

use shareid fshare mshare using 500k_fam1, clear
renvars fshare mshare \ share1 share2
gen n=_n
reshape long share, i(n)
drop n _j
drop if share==0
rename shareid iid1
rename share shareid
sort shareid
merge m:1 shareid using 500k_fam1, keepusing(shareid) nogen keep(3)
rename shareid iid2
gen pc=_n
reshape long iid, i(pc)
drop _j
save 500k_pc, replace

use 500k_pc, clear
sort iid
savasas using pc, replace

***** random pairs analysis at SNP level *****
* all programs in "rp" folder
